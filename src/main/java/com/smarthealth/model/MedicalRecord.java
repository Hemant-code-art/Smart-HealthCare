package com.smarthealth.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class MedicalRecord {
    private int id;
    private int patientId;
    private int doctorId;
    private Integer appointmentId; // Nullable
    private LocalDate visitDate;
    private String chiefComplaint;
    private String diagnosis;
    private String treatmentPlan;
    private String vitalsBp;
    private BigDecimal vitalsTemp;
    private Short vitalsPulse;
    private BigDecimal vitalsWeightKg;
    private BigDecimal vitalsHeightCm;
    private String notes;

    // Helper display fields
    private String patientName;
    private String doctorName;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }

    public Integer getAppointmentId() { return appointmentId; }
    public void setAppointmentId(Integer appointmentId) { this.appointmentId = appointmentId; }

    public LocalDate getVisitDate() { return visitDate; }
    public void setVisitDate(LocalDate visitDate) { this.visitDate = visitDate; }

    public String getChiefComplaint() { return chiefComplaint; }
    public void setChiefComplaint(String chiefComplaint) { this.chiefComplaint = chiefComplaint; }

    public String getDiagnosis() { return diagnosis; }
    public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }

    public String getTreatmentPlan() { return treatmentPlan; }
    public void setTreatmentPlan(String treatmentPlan) { this.treatmentPlan = treatmentPlan; }

    public String getVitalsBp() { return vitalsBp; }
    public void setVitalsBp(String vitalsBp) { this.vitalsBp = vitalsBp; }

    public BigDecimal getVitalsTemp() { return vitalsTemp; }
    public void setVitalsTemp(BigDecimal vitalsTemp) { this.vitalsTemp = vitalsTemp; }

    public Short getVitalsPulse() { return vitalsPulse; }
    public void setVitalsPulse(Short vitalsPulse) { this.vitalsPulse = vitalsPulse; }

    public BigDecimal getVitalsWeightKg() { return vitalsWeightKg; }
    public void setVitalsWeightKg(BigDecimal vitalsWeightKg) { this.vitalsWeightKg = vitalsWeightKg; }

    public BigDecimal getVitalsHeightCm() { return vitalsHeightCm; }
    public void setVitalsHeightCm(BigDecimal vitalsHeightCm) { this.vitalsHeightCm = vitalsHeightCm; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }
}
