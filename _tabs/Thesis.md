---
title: Thesis
order: 1
icon: fas fa-bolt
---

See the full repository
<a href="https://github.com/chaserobertson/tesla-stlf" target="_blank">on GitHub</a>
for source data files, scripts, notebooks, and more.

{% assign files = site.static_files | where_exp: "file", "file.basename contains 'Thesis'" %}

[Download File]({{ files[0].path }})
(Last Updated: {{ files[0].modified_time | date: "%Y-%m-%d" }})

<object data="{{ files[0].path }}" type="application/pdf" width="100%" height=700px>
    <embed src="{{ files[0].path }}">
        <p>This browser does not support PDFs. You can view it <a href="{{ site.baseurl }}{{ files[0].path }}">here</a>.</p>
    </embed>
</object>
