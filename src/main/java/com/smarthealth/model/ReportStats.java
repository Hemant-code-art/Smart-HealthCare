package com.smarthealth.model;

public class ReportStats {
    private int totalAppointments;
    private int pendingAppointments;
    private int approvedAppointments;
    private int rejectedAppointments;
    private int cancelledAppointments;
    private int totalPatients;
    private int totalDoctors;

    public int getTotalAppointments() {
        return totalAppointments;
    }

    public void setTotalAppointments(int totalAppointments) {
        this.totalAppointments = totalAppointments;
    }

    public int getPendingAppointments() {
        return pendingAppointments;
    }

    public void setPendingAppointments(int pendingAppointments) {
        this.pendingAppointments = pendingAppointments;
    }

    public int getApprovedAppointments() {
        return approvedAppointments;
    }

    public void setApprovedAppointments(int approvedAppointments) {
        this.approvedAppointments = approvedAppointments;
    }

    public int getRejectedAppointments() {
        return rejectedAppointments;
    }

    public void setRejectedAppointments(int rejectedAppointments) {
        this.rejectedAppointments = rejectedAppointments;
    }

    public int getCancelledAppointments() {
        return cancelledAppointments;
    }

    public void setCancelledAppointments(int cancelledAppointments) {
        this.cancelledAppointments = cancelledAppointments;
    }

    public int getTotalPatients() {
        return totalPatients;
    }

    public void setTotalPatients(int totalPatients) {
        this.totalPatients = totalPatients;
    }

    public int getTotalDoctors() {
        return totalDoctors;
    }

    public void setTotalDoctors(int totalDoctors) {
        this.totalDoctors = totalDoctors;
    }
}
