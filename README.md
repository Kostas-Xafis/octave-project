# DSS Project

## Execution

### To execute the project, run the following commands:

```bash
# To clone the project, run the following command:
git clone https://Kostas-Xafis/octave-project.git

# Change directory to the project's root directory
cd ./octave-project

#Either run the following commands through the octave gui or the octave-cli

# To generate the experts criteria and alternatives, calculate the weights and the final ranking, run the following command:  
octave-cli ./dss_study.m --experts|-e num_of_experts --output|-o mat_output_file

# To do sensitivity analysis, run the following command:
octave-cli ./sensitivity_analysis.m --input_file|-f input_file_of_data --iterations|-i num_of_mc_iterations

# To generate the report with the charts, run the following command:
octave-cli ./generate_charts.m
```

> [!IMPORTANT]
> To generate the final report you will need to do sensivity analysis for all 3 types of susceptibility levels. And therefor you will need to run the dss_study.m enought times to generate the necessary susceptibility level and then do the sensitivity analysis for each one of them.

> [!WARNING]
> This is not thouroughly tested inside the octave gui, so it is recommended to run the commands through the octave-cli.

