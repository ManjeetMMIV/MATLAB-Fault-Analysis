# MATLAB-Fault-Analysis
A MATLAB-based GUI application for simulating and analyzing balanced and unbalanced faults in power transmission lines.

## 📌 Features

- Fault Type Analysis:
  - Balanced (3-phase) faults
  - Unbalanced faults:
    - Line-to-Ground (LG)
    - Line-to-Line (LL)
    - Double Line-to-Ground (LLG)
- Interactive GUI with intuitive controls
- Real-time calculations:
  - Fault current magnitude
  - Fault power
- Visualizations:
  - Current magnitude gauge
  - Time-domain waveform plotting
- User-friendly input system for power system parameters

## 🛠️ Technical Implementation

### Key Components
1. Fault Current Calculations:
   ```matlab
   % Balanced fault example
   Z_total = Z_source + Z_line + R_fault;
   I_fault = V_system / Z_total;
Symmetrical Components for unbalanced faults

MATLAB App Designer for GUI implementation

Formulas Implemented
Fault Type	Formula
Balanced	I_f = V / (Z_s + Z_l + R_f)
LG Fault	I_f = 3V / (Z_1 + Z_2 + Z_0 + 3R_f)
LL Fault	I_f = sqrt(3)V / (Z_1 + Z_2 + R_f)

🚀 Getting Started
Prerequisites
MATLAB R2020b or later

MATLAB App Designer (included in standard MATLAB license)

Installation
Clone the repository

Open MATLAB and navigate to the project directory

Run faultAnalysisApp.m to launch the application

🖥️ Usage
Select fault type (Balanced / Unbalanced)

Enter system parameters:

System voltage (kV)

Source impedance (Ω)

Line impedance (Ω)

Fault resistance (Ω)

Click "Submit" to calculate results

View fault current and power outputs

Analyze the current waveform plot

🧠 Theory Background
Symmetrical component analysis

Per-unit system calculations

AC circuit theory for fault conditions

Phasor analysis of power systems
