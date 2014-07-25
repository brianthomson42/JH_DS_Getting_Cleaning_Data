###Introduction
The purpose of this README is to describe how the run_analysis.R script can be used to consume the dataset described in the associated Cookbook and produce a tidy dataset so that further data analysis and reporting can be conducted. It is imperative that the analysis conducted is reproduceable by other analysts so that findings can be corroborated or refuted as appropriate.
The dataset in question is based upon Human Activity Recognition Using Smartphones in which 30 human subjects had a variety of smart phone sensor signal measurements recorded over time during 6 distinct daily activities. A more detailed synopsis can be found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
The goal of this exercise is to explain in detail how to take raw data and "tidy" it according to a set of principles in order to make it fit for further analysis. This 'tidying' process is a crucial component of the scientific data analysis process. In concert with the aforementioned tidy dataset is a corresponding Codebook which describes the data with sufficient precision and clarity so as to discourage any ambiguity or assumptions being made about the data.


###Development Environment
The initial analysis was conducted in the following computing environment.

|    Name | Version   |
|    ----:|:-------   |
| RStudio | 0.98.953  |
|       R | 3.0.2     |
|  Ubuntu | 14.04 LTS |
|  Lenovo | T420      |


###Structure
The computer program developed to conduct the analysis is written in the R statistical programming language. In order to reproduce the analysis the R language will have to be installed as a minimum. It can be downloaded from [here](http://www.r-project.org/). It is preferrable if the RStudio IDE is also installed as it provides functionality for convenient viewing of data. RStudio can be downloaded from [here](http://www.rstudio.com/products/rstudio/download/). This is important for human readability due to the dimensions of the datasets involved.
The run_analysis.R script is itself very straightforward in structure. Comprising primarily of in-line code aside from a couple of functions which are used to rename variable names in the tidy data set. The script is self-contained insomuch as all aspects of the analysis from data acquisition to the production of the final tidy dataset is contained within a single computer program. While not optimal from a software engineering perspective this approach is considered to be optimized from the point of view of the researcher wishing to reproduce the analysis in as straightforward a manner as possible. As such the script does not even require specific command line arguments. This was done deliberately as RStudio does not currently support being able to invoke a script with command line arguments.


###Invocation
The run_analysis.R script can be invoked in a number of ways.

1. Within a terminal window using standard unix invocation.
   Messages are printed to the console as follows.

```
-> % chmod u+x run_analysis.R  # ensure script is executable
-> % ./run_analysis.R        
Extract HAR Data zipfile to ./data ... done

Create a single test dataset ... done

Create a single train dataset ... done

Combine the test and train datasets into a single dataset ... done

Create a tidy dataset ... done

Write tidy dataset to HAR_tidy_data.txt ... done

```


2. Within a terminal window using 'R CMD'.

```
-> % R CMD BATCH run_analysis.R
-> %
```
No output is printed to the console. However, a file called `run_analysis.Rout` is created in the current working directory which contains information about the R environment, the script source code and any messages that it outputs, plus the time the program takes to execute. By way comparison, an example of the execution timing in the author's computing environment is.
```
> proc.time()
   user  system elapsed 
 29.100   4.780  62.091
```
Note that 29.100 seconds represents the the real time of script execution. In this case it includes the downloding of the zipfile dataset from the Internet. For the purposes of this course the script has been modified to expect the dataset zipfile to already have been downloaded. i.e. the file 'getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip' already exists in the same directory as the run_analysis.R script.


3. Within RStudio.
  3.1 Session -> Set Working Directory -> Choose Directory -> (navigate to directory containing run_analysis.R) -> Open
  3.2 Code  -> Source File -> (navigate to run_analysis.R) --> Open
This will execute the script. Output similar to that documented above for #1 will be printed to the RStudio console window pane. The Global Environment window pane shows the Data, Values and Functions created by the script. The most useful of which is the casted_df dataframe. If you click on the icon on the RHS it will run the View() command in the console. This will display in a nice human readable format the tidy dataset which gets written to the 'HAR_tidy_data.txt' file in the current working directory.
If you read the supplied 'tidy_data.txt' manually into R via the read.table command. You should get a dataframe which is the same as that assigned to the 'casted_df' variable.


All of the above methods produce a file called 'HAR_tidy_data.txt'. Each observation is on a separate line. Each variable per line is separated by a single space.
