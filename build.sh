#!/bin/bash

# Fetch sentry-native, build, and generate jai bindings.
mkdir sentry-native
cd sentry-native
wget https://github.com/getsentry/sentry-native/releases/download/0.7.9/sentry-native.zip
unzip sentry-native.zip
cmake -B build
cmake --build build --parallel
cd ..
jai generate.jai

