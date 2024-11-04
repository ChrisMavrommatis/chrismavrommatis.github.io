---
title:  "How I reduced memory usage by 70% in Binacle.Net"
layout: "blog_detail"
title_class: "small"
main_img: "https://picsum.photos/400/150"
tags: 
  - .Net 
  - Memory Management
  - Binacle.Net
---


In this article, I’ll take you through my journey of optimizing memory in **Binacle.Net**, an API built in **C#** and **.NET**.

## Introduction

**Binacle.Net** started as a hobby project aimed at solving the **3D Bin Packing Problem** in real-time. The API has grown to include a range of algorithms, some fully developed and others still in progress.

At the time of writing **Binacle.Net** includes both **Fitting** and **Packing** functions. While these functions might use algorithms with similar names, they are distinct in purpose and output. The **Fitting function** assesses whether all items can fit within a bin, while the **Packing function** aims to maximize bin space by fitting as many items as possible and tracking their positions.

The performance and memory data in this article were derived using [BenchmarkDotNet](https://benchmarkdotnet.org/){:.link} in **.Net 8** and are specific to this algorithm and its application within **Binacle.Net’s Fitting function**.

The charts were made with [chartbenchmark.net](https://chartbenchmark.net/){:.link}, and the memory usage is indicated by the thin purple line within the larger bar which indicates execution time.

## The Problems

It's important to take you back before the **Fitting and Packing functions** existed.

The very first problem I encountered was the creation of algorithms with, apparently, over 90% memory reduction. This, as you can imagine, were algorithms that didn't run at all. The solution to that was tests, with scenarios crafted by hand that guaranteed, to an extent, the new algorithm operated correctly, before starting to run the benchmarks.

The algorithms were based on a common interface, which made it easy to switch between different versions and, in the future, different types of algorithms, whilst providing a fairly equal testing environment. This, however, presented a new problem, one that I have to this day.

Each time I needed to refactor the common interface, the original algorithm's performance could potentially change as well. I could not easily maintain the original algorithm just for historical reasons, so I decided, the benefits that the common interface provides are significantly more valuable than preserving the original algorithm through refactor and test iterations.

The graph below, is the first I have records of. During that time, the algorithm accepted many bins, but only returned the smallest applicable.

![First chart in record](/assets/posts/how-i-reduced-memory-usage-by-70-percent-in-Binacle-net/01_chart_init_public_run.png){:.responsive}

The 2nd version showed improvements, but something was wrong, both versions dropped when they hit 1000 items. After more investigation I realized that somewhere between 500 and 1000 items, the bins hit their limit and the items could no longer fit into any bin, meaning the algorithms exited early. This was evidenced by the sudden drop in the chart as well, which later, I confirmed it by running the calculations by hand.

For clarity I was using only 5 cm cubes to do the benchmarks, so it was pretty easy to determine how many would fit.

After that, I decided to do a more precise run. From the calculations I had, I created new test cases.

The values were carefully chosen so I could see the performance breakpoints of each bin. There are 3 bin sizes, the smallest fits up to 192 items, while the medium fits up to 384 items and the large one fits up to 576.

![Second chart, more precise](/assets/posts/how-i-reduced-memory-usage-by-70-percent-in-Binacle-net/02_chart_2024_04_12.png){:.responsive}

Looking at the second chart carefully, I could see that the algorithm spiked dramatically from 192 to 193 items, from 384 to 385 and then it would predictably drop at 577 items.

This made me understand that the algorithm didn’t detect that the items could not fit in the smaller size bins and tried to fit them until it failed, and only then moved on to next bin size.
Version 2 had that issue fixed. You can see the spikes are present in version 1, but not in version 2, where it smoothly scales up.

Furthermore, as evidenced by the chart, in the early exit scenario where no bin could accommodate all the items, version 1 of the algorithm was more performant than version 2. This was all due to how version 2 was created.

## The Refactor

After a few months I began to create another algorithm, what would later be named as the **Packing function**. Initially, I named it Version 3, as all that came before it. Eventuallylater, I changed my mind, as the algorithm essentially produced a different result. It was still in lines with the **First Fit Decreasing**, but it had a different purpose. It kept track of the positions of the items and it would try to pack as much as possible.

Due to how the new algorithm worked, it had visibly worse performance, after all, it had more work to do.

![Third chart. With Version 3](/assets/posts/how-i-reduced-memory-usage-by-70-percent-in-Binacle-net/03_chart_2024-08-30.png){:.responsive}

Realizing this new algorithm function had an entirely different purpose I began refactoring the algorithms to separate the two, which gave birth to the **Fitting and Packing functions**.

Through this refactor iteration I had to throw out the common interface entirely and create two new ones. As such, the performance of the original algorithm changed as well.

![Fourth chart. After separation](/assets/posts/how-i-reduced-memory-usage-by-70-percent-in-Binacle-net/04_chart_2024-09-15.png){:.responsive}

This was also the time the algorithms stopped accepting multiple bins.

## Now

After the refactoring I began to further improve the algorithms, and after many attempts and versions, some of which were merged, I ended up with the following.

![Fifth chart. Only Fitting function algortihms](/assets/posts/how-i-reduced-memory-usage-by-70-percent-in-Binacle-net/05_chart_2024-10-18_fitting.png){:.responsive}

The graph now only shows the **Fitting function** as this is the subject of this article. It also displays a 70% memory reduction between version 1 and version 3, as well as a little over 50% reduction in excecution time.

Bellow is the table with the actual numbers.

| Method         | NoOfItems | Mean       | Error     | StdDev    | Median     | Ratio | RatioSD | Gen0    | Allocated | Alloc Ratio |
|--------------- |---------- |-----------:|----------:|----------:|-----------:|------:|--------:|--------:|----------:|------------:|
| **Fitting_FFD_V1** | **10**        |  **23.091 μs** | **0.4605 μs** | **1.2051 μs** |  **22.663 μs** |  **1.00** |    **0.07** |  **1.9531** |   **5.99 KB** |        **1.00** |
| Fitting_FFD_V2 | 10        |  12.562 μs | 0.2427 μs | 0.2151 μs |  12.557 μs |  0.55 |    0.03 |  1.0529 |   3.26 KB |        0.54 |
| Fitting_FFD_V3 | 10        |   9.908 μs | 0.1333 μs | 0.1182 μs |   9.886 μs |  0.43 |    0.02 |  0.7477 |    2.3 KB |        0.38 |
|                |           |            |           |           |            |       |         |         |           |             |
| **Fitting_FFD_V1** | **70**        | **128.198 μs** | **2.5180 μs** | **2.5858 μs** | **127.988 μs** |  **1.00** |    **0.03** | **10.0098** |  **30.91 KB** |        **1.00** |
| Fitting_FFD_V2 | 70        |  68.411 μs | 1.2600 μs | 1.2375 μs |  68.635 μs |  0.53 |    0.01 |  4.5166 |  14.02 KB |        0.45 |
| Fitting_FFD_V3 | 70        |  59.717 μs | 1.1810 μs | 2.2182 μs |  59.333 μs |  0.47 |    0.02 |  3.1738 |   9.77 KB |        0.32 |
|                |           |            |           |           |            |       |         |         |           |             |
| **Fitting_FFD_V1** | **130**       | **232.221 μs** | **4.4224 μs** | **5.7504 μs** | **230.766 μs** |  **1.00** |    **0.03** | **17.8223** |  **54.98 KB** |        **1.00** |
| Fitting_FFD_V2 | 130       | 123.661 μs | 2.2121 μs | 2.7166 μs | 123.454 μs |  0.53 |    0.02 |  7.5684 |  23.92 KB |        0.44 |
| Fitting_FFD_V3 | 130       | 105.357 μs | 1.6066 μs | 1.5028 μs | 105.367 μs |  0.45 |    0.01 |  5.2490 |  16.39 KB |        0.30 |
|                |           |            |           |           |            |       |         |         |           |             |
| **Fitting_FFD_V1** | **192**       | **364.521 μs** | **6.9847 μs** | **6.5335 μs** | **363.258 μs** |  **1.00** |    **0.02** | **24.9023** |  **77.19 KB** |        **1.00** |
| Fitting_FFD_V2 | 192       | 178.677 μs | 2.9441 μs | 2.6098 μs | 177.678 μs |  0.49 |    0.01 | 10.7422 |  33.65 KB |        0.44 |
| Fitting_FFD_V3 | 192       | 159.475 μs | 2.1216 μs | 1.9845 μs | 158.870 μs |  0.44 |    0.01 |  7.3242 |  22.73 KB |        0.29 |
|                |           |            |           |           |            |       |         |         |           |             |
| **Fitting_FFD_V1** | **202**       |  **79.654 μs** | **1.4574 μs** | **1.2919 μs** |  **80.027 μs** |  **1.00** |    **0.02** |  **4.6387** |   **14.3 KB** |        **1.00** |
| Fitting_FFD_V2 | 202       |  34.895 μs | 0.6630 μs | 0.7636 μs |  34.790 μs |  0.44 |    0.01 |  4.2114 |  13.01 KB |        0.91 |
| Fitting_FFD_V3 | 202       |  30.055 μs | 0.4198 μs | 0.3927 μs |  29.987 μs |  0.38 |    0.01 |  4.2114 |  12.95 KB |        0.91 |

## How I did it



The most significant change I made in terms of work and gain, was how I handled the orientations of the items. The first version returns an entirely new object through an iterator.

{% highlight csharp %}
internal IEnumerable<Item> GetOrientations()
{
  yield return new Item(this.ID, this.Length, this.Width, this.Height);
  yield return new Item(this.ID, this.Length, this.Height, this.Width);

  yield return new Item(this.ID, this.Width, this.Length, this.Height);
  yield return new Item(this.ID, this.Width, this.Height, this.Length);

  yield return new Item(this.ID, this.Height, this.Length, this.Width);
  yield return new Item(this.ID, this.Height, this.Width, this.Length);
}
{% endhighlight %}

While the next version kept an internal state in the item, needing 6 properties for the dimensions instead of 3.

{% highlight csharp %}
private sealed class Item
{
  private int originalLength;
  private int originalWidth;
  private int originalHeight;

  private ushort currentOrientation;

  public int Length { get; set; }
  public int Width { get; set; }
  public int Height { get; set; }

  internal Item Rotate()
  {
    // Handle the rotation logic
  }

}
{% endhighlight %}

This is the main reason why Version 1 innitially had better performance in an early exit scenarion.

The next few changes, while small, had also a big impact on memory, much bigger that I initially imagined.

The first was the elimination of LINQ as much as possible, specifically all the methods that had closures. Those parts were rewritten to perform a loop instead.

Speaking of loops, while I was dealing with lists or arrays I made sure to itterate using the `Count` and `Length` properties and not allocated extra memory for an itterator.
