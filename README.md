# MATLAB Library for Evaluating Markovian Queueing Systems

This repository contains the source code and interface developed as part of my Bachelor's thesis:  
**"Development of a MATLAB Library for Performance Evaluation of Markovian Queueing Systems."**

The project aims to provide an interactive and extensible MATLAB tool for analyzing various types of queueing models based on Markov chains, both theoretically and through simulation.

## 🎯 Objectives

- Implement analytical and simulation-based evaluations of queueing systems.
- Support a wide range of models: M/M/1, M/M/m, M/M/m/K, M/M/m/K/p, and phase-type queues.
- Enable performance indicators calculation: utilization, average waiting time, queue length, etc.
- Compare theoretical vs. simulation results.
- Provide an easy-to-use **GUI** for educational and experimental purposes.

## 📦 Features

- **Model selection**: choose among several queue types.
- **Input parameters**: arrival rate, service rate, number of servers, buffer size, etc.
- **Computed metrics**:  
  - Average number of customers in the system (L)  
  - Average waiting time (W)  
  - Utilization (ρ)  
  - Blocking probability (if applicable)
- **Simulation mode** with discrete-event logic.
- **Graphical plots** for visual analysis.

## 🛠 Technologies

- Developed in **MATLAB R2023a**
- Uses built-in MATLAB plotting and UI components (App Designer)

## 🚀 Getting Started

1. Open the MATLAB project.
2. Run `Main_GUI.mlapp` or `QueueingLibraryApp.mlapp`
3. Choose the model and input parameters.
4. Click **Calculate** or **Simulate** to obtain results.

## 📁 Project Structure

- `/models` – analytical functions for each queue type
- `/simulations` – event-based simulation engine
- `/gui` – main graphical interface
- `/examples` – example use cases with saved parameters

## 📘 License

This project is intended for academic and educational purposes. Free to use with attribution.

## 👤 Author

Developed by Ștefan Atomulesei  
Bachelor of Automation and Computer Science  
Technical University of Iași (2025)

