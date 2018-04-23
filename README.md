# Facets of phylodiversity

This repository contains supporting material associated with the study entitled "Facets of phylodiversity: parsing the value of anagenesis, cladogenesis, and evolutionary time in spatial conservation prioritization," currently in review:

A raster file containing the dataset we developed representing current [land conservation status](protection_status.tif) on a 0--1 scale, at 810m grain size. 

An R script with functions implementing our [reserve selection algortihm](prioritize.R).

A CSV file containing our [prioritization results](rankings.csv). For each 15km grid cell this file contains the spatial coordinates (Albers equal-area, EPSG:3310, 15 km resolution), current conservation status, proportion of the cell in the state, and prioritization rankings for each of six different biodiversity metrics.

Our analysis was based on previously published input datasets that are also available online, including [herbarium records](https://doi.org/10.6078/D1KX0V), [phylogenetic trees](https://doi.org/10.6078/D1VD4P), and [species distribution model](https://doi.org/10.6078/D1QQ2S) scripts.

The authors of this study are Matthew Kling, Brent Mishler, Andrew Thornhill, Bruce Baldwin, and David Ackerly.
