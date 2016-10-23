---
layout: post
title:  ArcGIS legend tip
---
Sometimes I found the symbols of my points are too small to be distinguished. For example I have training and testing points. These points have to be small on the map so that they do not mess up with other polygons. However, if I want to have a legend of these types of points, also I want the shape & color of the symbols could be distinguished in the legend. The size of symbol in the legend does not have to be huge, just maybe 3 times larger than the original size. Unfortunately, ArcGIS does not have such parameters to do so.  

As I know, there are two ways to deal with this problem. One way is to export the map from ArcGIS, then edit in Photoshop, Powerpoint, or other software. The drawback is you need extra efforts to edit color, shape, text, and position of the legend.  

So can I do all the work ArcGIS? Yes! Here is my procedure:  
  
* (1) Have a copy of the layer in ArcGIS (a copy of the shape file of training points);  

* (2) Change the symbol size of the copied layer to 3 times bigger (or a preferred size you want);  

* (3) Make the copied layer invisible in the map;  

* (4) Open legend properties, and unchecked "only display layers that are checked in the Table of Contents " (so that you could add and hide whatever you want in the legend);  

* (5) Add the copied layer into the list of "Legend Items"and remove the original layer from this list.  

So finally I have small and cute points shown in the map, and I have big and clear points in the legend.  

<img src="{{ site.url }}/figure/old_post/gis1.png" alt="network1" style="width: 300px;" align="middle"/>  