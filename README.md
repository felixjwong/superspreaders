<!--
*** Thanks for checking out this README Template. If you have a suggestion that would
*** make this better, please fork the repo and create a pull request or simply open
*** an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
-->




<!-- PROJECT LOGO -->
<br />
<p align="center">

  <h3 align="center">Extreme value statistics reveals tail risks of coronavirus superspreading</h3>

  <p align="center">
    Supporting code for the paper
  </p>
</p>



<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the Code](#about-the-project)
* [Running the code](#running-the-code)
  * [What the code contains](#what-the-code-contains)
  * [Usage](#usage)
* [Contact](#contact)



<!-- ABOUT THE PROJECT -->
## About the Code

The code in this repository allows for repeat and independent analysis of the one described in the paper "Extreme value statistics reveals tail risks of coronavirus superspreading", by Wong et al. The code requires MATLAB 2019b or later to run. 

<!-- GETTING STARTED -->
## Running the code


### What the code contains

There are a total of four files included:

* sspreader.m
<p>
This file is the main analysis script. It loads all the data and generates nearly all figures and analyses shown in the main text.
</p>

* sspreader_robustness.m
<p>
This file performs the robustness check shown in Fig. 2F of the main text.
</p>

* hillestimator.m
<p>
Auxiliary script for computing the Hill estimator. 
</p>

* polyparci.m
<p>
Auxiliary script for estimating polynomial fit confidence intervals.
</p>

<p>
<b>Please note:</b> Dataset S1 of the paper contains more details of, and references for, the superspreading events.
</p>


### Usage

To run the main analysis, simply run in MATLAB:
```sh
sspreader
```
All analysis results should appear. To run the robustness check after the main analysis has been executed, run in MATLAB:
```sh
sspreader_robustness
```

<!-- CONTACT -->
## Contact

For questions or comments about this code, please reach out to felix j wong at gmail (no spaces, add domain name). 



