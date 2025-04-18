import streamlit as st
import pandas as pd
import plotly.express as px
import numpy as np
from sklearn.ensemble import IsolationForest
from sklearn.preprocessing import StandardScaler

st.set_page_config(page_title="Waste Collection Dashboard", layout="wide")

# Load and process data
df = pd.read_csv('extraction_data.csv')
df['collectionTime'] = pd.to_datetime(df['collectionTime'], format='%d/%m/%Y %H:%M')
df_sorted = df.sort_values(by='collectionTime')
df_sorted['date'] = df_sorted['collectionTime'].dt.date
df_sorted['actualWeight'] = df_sorted.groupby('date')['cleanedWeight'].diff().fillna(0)
df_clean = df_sorted[df_sorted['binCenterName'] != 'NUS - Use for Reference Weight']

# Add bin location information
data_locations = [
    ('1. UTown Residence - South Tower', 1.3053867028982664, 103.77395411402797),
    ('2. UTown Residence - North Tower', 1.3068623859969037, 103.77356978330968),
    ('3. Tembusu/Cinnamon College', 1.308133475737056, 103.7732636240817),
    ('4. College of Alice and Peter Tan/RC4', 1.3084262413493235, 103.77343958175372),
    ('5. Yale-NUS - 12 College Ave West', 1.3070708893592056, 103.77185893942554),
    ('6. Yale-NUS - 28 College Ave West', 1.3079253193849210, 103.77199592392012)
]

location_df = pd.DataFrame(data_locations, columns=['binCenterName', 'latitude', 'longitude'])
df_clean = df_clean.merge(location_df, on='binCenterName', how='left')

# Extract additional time information
df_clean['day_of_week'] = df_clean['collectionTime'].dt.day_name()

# Streamlit app layout with enhancements
st.title('Interactive Waste Collection Dashboard 🗑️')
st.markdown("""
    Welcome to the Waste Collection Analysis Dashboard!
    This tool helps visualize and explore waste data across various locations in NUS.
""")

st.sidebar.header('Filters 🔍')
st.sidebar.markdown("---")

# Sidebar filters (refactored for range date picker)
date_range = st.sidebar.date_input("Select Date Range", [df_clean['collectionTime'].min().date(), df_clean['collectionTime'].max().date()])
start_date, end_date = date_range[0], date_range[1]

# Bin center filter
bin_centers = st.sidebar.multiselect(
    'Select Bin Centers',
    options=df_clean['binCenterName'].unique(),
    default=df_clean['binCenterName'].unique()
)

# Days of the week filter
days_of_week = st.sidebar.multiselect(
    'Select Days of the Week',
    options=df_clean['day_of_week'].unique(),
    default=df_clean['day_of_week'].unique()
)

# Filter data based on selections
df_filtered = df_clean[
    (df_clean['binCenterName'].isin(bin_centers)) &
    (df_clean['day_of_week'].isin(days_of_week)) &
    (df_clean['collectionTime'].dt.date >= start_date) &
    (df_clean['collectionTime'].dt.date <= end_date)
]

# Add Metrics to the top
if not df_filtered.empty:
    max_weight = df_filtered['actualWeight'].max()
    max_bin_center = df_filtered[df_filtered['actualWeight'] == max_weight]['binCenterName'].values[0]
    avg_weight = df_filtered['actualWeight'].mean()
    total_weight = df_filtered['actualWeight'].sum()
    col1, col2, col3 = st.columns(3)
    col1.metric(label="Max Waste Collected", value=f"{max_weight:.2f} kg", help=f"Collected at {max_bin_center}")
    col2.metric(label="Average Waste per Collection", value=f"{avg_weight:.2f} kg")
    col3.metric(label="Total Waste Collected", value=f"{total_weight:.2f} kg")

    # Adding a new percentage metric
    if len(df_filtered) > 1:
        previous_weight = df_filtered.iloc[-2]['actualWeight']
        percentage_change = ((max_weight - previous_weight) / previous_weight) * 100 if previous_weight != 0 else 0
        col1.metric(label="Percentage Change in Max Weight", value=f"{percentage_change:.2f}%")

# Enhanced Waste Collection by Location (latest day only)
st.write("### Waste Collection by Location (Latest Day)")
if not df_filtered.empty:
    latest_date = df_filtered['collectionTime'].dt.date.max()
    df_latest = df_filtered[df_filtered['collectionTime'].dt.date == latest_date]
    if not df_latest.empty:
        fig_map = px.scatter_mapbox(
            df_latest.dropna(subset=['latitude', 'longitude']),
            lat='latitude',
            lon='longitude',
            color='actualWeight',
            size='actualWeight',
            hover_name='binCenterName',
            hover_data={'actualWeight': ':.2f', 'collectionTime': True},
            color_continuous_scale=['green', 'red'],
            size_max=40,
            zoom=16,
            center=dict(lat=1.3084262413493235, lon=103.77343958175372),
            title='Waste Collection by Bin Center Location (Latest Day)'
        )
        fig_map.update_layout(mapbox_style='carto-positron')
        fig_map.update_layout(margin={'r':0,'t':30,'l':0,'b':0})
        st.plotly_chart(fig_map, use_container_width=True)
    else:
        st.write("No data available for the latest day.")
else:
    st.write("No data available for the selected filters.")

# Waste Collection Trend Over Time by Location
st.write("### Waste Collection Trend Over Time by Location")
if not df_filtered.empty:
    fig_line_location = px.line(
        df_filtered,
        x='collectionTime',
        y='actualWeight',
        color='binCenterName',
        title='Waste Collection Trend Over Time by Location'
    )
    fig_line_location.update_layout(xaxis_title='Collection Time', yaxis_title='Weight Collected (kg)')
    st.plotly_chart(fig_line_location, use_container_width=True)
else:
    st.write("No data available for the selected filters.")

# Anomaly Detection by Location using Rolling Mean and Standard Deviation
st.write("### Anomaly Detection in Waste Collection by Location")
if not df_filtered.empty:
    df_anomalies = []
    for bin_center in df_filtered['binCenterName'].unique():
        df_bin = df_filtered[df_filtered['binCenterName'] == bin_center].copy()
        df_bin['rolling_mean'] = df_bin['actualWeight'].rolling(window=7, min_periods=1).mean()
        df_bin['rolling_std'] = df_bin['actualWeight'].rolling(window=7, min_periods=1).std()
        df_bin['upper_bound'] = df_bin['rolling_mean'] + 2 * df_bin['rolling_std']
        df_bin['lower_bound'] = df_bin['rolling_mean'] - 2 * df_bin['rolling_std']
        df_bin['anomaly'] = ((df_bin['actualWeight'] > df_bin['upper_bound']) | (df_bin['actualWeight'] < df_bin['lower_bound'])).astype(int)
        df_anomalies.append(df_bin)

    if df_anomalies:
        df_anomaly_combined = pd.concat(df_anomalies)
        # Plot anomalies
        anomalies = df_anomaly_combined[df_anomaly_combined['anomaly'] == 1]
        fig_anomaly_location = px.scatter(
            df_anomaly_combined,
            x='collectionTime',
            y='actualWeight',
            color='anomaly',
            color_continuous_scale=['green', 'red'],
            title='Anomaly Detection in Waste Collection by Location',
            labels={'anomaly': 'Anomaly (Red indicates anomalies)'}
        )
        fig_anomaly_location.update_traces(marker=dict(size=10, opacity=0.6))
        fig_anomaly_location.update_layout(xaxis_title='Collection Time', yaxis_title='Weight Collected (kg)')
        st.plotly_chart(fig_anomaly_location, use_container_width=True)
    else:
        st.write("No anomalies detected for the selected locations.")
else:
    st.write("No data available for anomaly detection.")

# User download option
st.download_button(
    label="Download Filtered Data",
    data=df_filtered.to_csv().encode('utf-8'),
    file_name='filtered_waste_data.csv',
    mime='text/csv'
)

# Conclusion and Feedback
st.write("### Thank you for exploring the Waste Collection Dashboard! 🌱")
feedback = st.sidebar.text_area("Have feedback? Share it here:")
if feedback:
    st.write("**Thanks for your feedback!** We'll review it soon.")
