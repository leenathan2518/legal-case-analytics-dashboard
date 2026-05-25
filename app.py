import streamlit as st
import pandas as pd
import plotly.express as px

# =====================================================
# Page config
# =====================================================

st.set_page_config(
    page_title="Notary Case Dashboard",
    layout="wide"
)

st.caption(
    "Built with Python, Streamlit, Pandas, Plotly, and MySQL"
)

# =====================================================
# Load data
# =====================================================

case_records = pd.read_csv("exports/public_case_records.csv")

monthly_summary = pd.read_csv(
    "exports/monthly_case_summary.csv"
)

dashboard_overview = pd.read_csv(
    "exports/dashboard_overview.csv"
)

case_type_summary = pd.read_csv(
    "exports/case_type_summary.csv"
)

notary_performance = pd.read_csv(
    "exports/public_notary_performance.csv"
)

# =====================================================
# Date processing
# =====================================================

case_records["accept_date"] = pd.to_datetime(
    case_records["accept_date"]
)

case_records["month"] = (
    case_records["accept_date"]
    .dt.strftime("%Y-%m")
)

# =====================================================
# Sidebar filters
# =====================================================

st.sidebar.title("Notary Dashboard")

st.sidebar.markdown(
    """
    Interactive analytics dashboard for notary case management.
    """
)

st.sidebar.header("Dashboard Filters")

selected_case_type = st.sidebar.selectbox(
    "Select Case Type",
    ["All"] + sorted(case_records["case_type"].dropna().unique().tolist())
)

selected_notary = st.sidebar.selectbox(
    "Select Notary",
    ["All"] + sorted(case_records["notary"].dropna().unique().tolist())
)

page = st.sidebar.radio(
    "Navigation",
    [
        "Overview",
        "Case Analysis",
        "Notary Analysis",
        "Raw Data"
    ]
)

# =====================================================
# Apply filters
# =====================================================

filtered_cases = case_records.copy()

if selected_case_type != "All":
    filtered_cases = filtered_cases[
        filtered_cases["case_type"] == selected_case_type
    ]

if selected_notary != "All":
    filtered_cases = filtered_cases[
        filtered_cases["notary"] == selected_notary
    ]

# =====================================================
# Build filtered monthly summary
# =====================================================

filtered_monthly = (
    filtered_cases
    .groupby("month")
    .agg(
        total_cases=("case_id", "count"),
        total_fee=("notary_fee", "sum"),
        average_fee=("notary_fee", "mean")
    )
    .reset_index()
)

filtered_monthly["average_fee"] = filtered_monthly["average_fee"].round(2)

# =====================================================
# Dashboard title
# =====================================================

st.title("Notary Case Data Dashboard")

st.write("Interactive analytics dashboard for notary case records.")

# =====================================================
# Page navigation
# =====================================================

if page == "Overview":

    # =====================================================
    # KPI Cards
    # =====================================================

    total_cases = len(filtered_cases)
    total_fee = filtered_cases["notary_fee"].sum()
    average_fee = filtered_cases["notary_fee"].mean()
    total_notaries = filtered_cases["notary"].nunique()

    col1, col2, col3, col4 = st.columns(4)

    col1.metric("Total Cases", f"{total_cases:,}")
    col2.metric("Total Fee", f"${total_fee:,.2f}")
    col3.metric("Average Fee", f"${average_fee:,.2f}")
    col4.metric("Total Notaries", f"{total_notaries}")

    st.divider()

    col_left, col_right = st.columns(2)

    with col_left:
        st.subheader("Monthly Case Trend")
        fig_cases = px.line(
            filtered_monthly,
            x="month",
            y="total_cases",
            markers=True,
            title="Monthly Case Volume"
        )
        st.plotly_chart(fig_cases, use_container_width=True)

    with col_right:
        st.subheader("Monthly Fee Trend")
        fig_fee = px.bar(
            filtered_monthly,
            x="month",
            y="total_fee",
            title="Monthly Fee Revenue"
        )
        st.plotly_chart(fig_fee, use_container_width=True)


elif page == "Case Analysis":

    st.subheader("Top Case Types")

    filtered_case_type_summary = (
        filtered_cases
        .groupby("case_type")
        .agg(
            total_cases=("case_id", "count"),
            total_fee=("notary_fee", "sum"),
            average_fee=("notary_fee", "mean")
        )
        .reset_index()
        .sort_values("total_cases", ascending=False)
    )

    filtered_case_type_summary["average_fee"] = (
        filtered_case_type_summary["average_fee"].round(2)
    )

    top_case_types = filtered_case_type_summary.head(10)

    fig_case_types = px.bar(
        top_case_types,
        x="total_cases",
        y="case_type",
        orientation="h",
        title="Top 10 Case Types by Volume"
    )

    st.plotly_chart(fig_case_types, use_container_width=True)
    st.dataframe(filtered_case_type_summary)


elif page == "Notary Analysis":

    st.subheader("Notary Performance")

    filtered_notary_performance = (
        filtered_cases
        .groupby("notary")
        .agg(
            total_cases=("case_id", "count"),
            total_fee=("notary_fee", "sum"),
            average_fee=("notary_fee", "mean")
        )
        .reset_index()
        .sort_values("total_cases", ascending=False)
    )

    filtered_notary_performance["average_fee"] = (
        filtered_notary_performance["average_fee"].round(2)
    )

    top_notaries = filtered_notary_performance.head(10)

    fig_notaries = px.bar(
        top_notaries,
        x="total_cases",
        y="notary",
        orientation="h",
        title="Top 10 Notaries by Case Volume"
    )

    st.plotly_chart(fig_notaries, use_container_width=True)
    st.dataframe(filtered_notary_performance)


elif page == "Raw Data":

    st.subheader("Detailed Case Records")

    st.dataframe(filtered_cases)

    csv_data = filtered_cases.to_csv(index=False).encode("utf-8")

    st.download_button(
        label="Download Filtered Data",
        data=csv_data,
        file_name="filtered_case_records.csv",
        mime="text/csv"
    )

