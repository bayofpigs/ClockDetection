ClockDetection
==============

Computer vision project 2014. Detecting clocks in images.

To run SVM detection:
In svm,
bboxes = generateBoundingBoxData();

To run DPM detection:
In voc-release5,
bboxes = generateBoundingBoxData();

Clock hand detection:
In geometry,
i = imread([filename]);
[hours minutes] = detect_time(i);
(click first on the center of the clock, then the outside edge)

Circle detection:
In geometry,
i = imread([filename]);
bbox = circle\_bounding\_box(i);

SVM code heavily borrows from problem set 5.
DPM code uses the source code from http://www.cs.berkeley.edu/~rbg/latent/
