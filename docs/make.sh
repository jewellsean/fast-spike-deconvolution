#!/usr/bin/env bash
Rscript build.R _source/tutorial.Rmd;
jekyll build
rm -rf docs
cp -r _site docs
jekyll serve
