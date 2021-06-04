# [Breast Cancer Wisconsin data](https://www.kaggle.com/uciml/breast-cancer-wisconsin-data) feature selection and modelling with R

## Selecting features by eliminating multicollinear and inseparable features and creating KNN, random Forest amnf Naive Bayes models

Multicollinearity occurs when variables (features) are strongly correlated. This can have negative impact on regression models` (such as KNN and Random Forest) ability to
separate relationship between each independent variable and the depandant variable

### Multicollinear features are easily detected from correlation plot:
![crp](https://i.gyazo.com/e7e15b1d011eb6665614d4cda66cdba4.png)

### Boxplots and swarmplots show feature distribution, from which inseparable feature can be detected
#### Y axes is logarithmic

Mean fetures

![bx1](https://i.gyazo.com/93c78651e5de22b014326e14e9df35c3.png)
![sp1](https://i.gyazo.com/da2e3b135a893d63181ba73e262bce5d.png)

Worst features

![bx2](https://i.gyazo.com/a88194824c942d260f20a28fc6ca12f1.png)
![sp2](https://i.gyazo.com/173b44a1e26e1f8d164168cc8813d4e9.png)

SE features

![bx3](https://i.gyazo.com/e0d0ba09ab54ce536a7aff3a8c887374.png)
![sp3](https://i.gyazo.com/88353b6c0c8830ea8538207df273f794.png)


### As a result, this features were selected:
```R
selected_features = c('diagnosis', 'radius_mean', 'texture_mean', 'smoothness_mean',
                   'compactness_mean','concavity_mean', 'fractal_dimension_worst',
                   'radius_se', 'texture_se', 'compactness_se')
```

### Comparison table of classifiers using all and selected features, with accuracy, sensitivity and specificity as metrics

<table class="tg">
<thead>
  <tr>
    <th class="tg-0pky" rowspan="2"></th>
    <th class="tg-0pky" colspan="3">All features</th>
    <th class="tg-0pky" colspan="3">Selected features</th>
  </tr>
  <tr>
    <td class="tg-0pky">Accuracy</td>
    <td class="tg-0pky">Sensitivity</td>
    <td class="tg-0pky">Specificity</td>
    <td class="tg-0pky">Accuracy</td>
    <td class="tg-0pky">Sensitivity</td>
    <td class="tg-0pky">Specificity</td>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-0pky">KNN</td>
    <td class="tg-0pky">0.95</td>
    <td class="tg-0pky">0.99</td>
    <td class="tg-0pky">0.89</td>
    <td class="tg-0pky">0.92</td>
    <td class="tg-0pky">0.97</td>
    <td class="tg-0pky">0.83</td>
  </tr>
  <tr>
    <td class="tg-0pky">Random Forest</td>
    <td class="tg-0pky">0.97</td>
    <td class="tg-0pky">0.99</td>
    <td class="tg-0pky">0.94</td>
    <td class="tg-0pky">0.95</td>
    <td class="tg-0pky">0.98</td>
    <td class="tg-0pky">0.89</td>
  </tr>
  <tr>
    <td class="tg-0pky">Naive Nayes</td>
    <td class="tg-0pky">0.94</td>
    <td class="tg-0pky">0.96</td>
    <td class="tg-0pky">0.9</td>
    <td class="tg-0pky">0.88</td>
    <td class="tg-0pky">0.93</td>
    <td class="tg-0pky">0.79</td>
  </tr>

</tbody>
</table>
