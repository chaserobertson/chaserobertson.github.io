---
title: CV
order: 3
icon: fas fa-address-card
---

{% assign cvs = site.static_files | where_exp: "file", "file.basename contains 'CV'" %}

[View Original]({{ cvs[0].path }})
(Last Updated: {{ cvs[0].modified_time | date: "%Y-%m-%d" }})

<object data="{{ cvs[0].path }}" type="application/pdf" width="100%" height=700px>
    <embed src="{{ cvs[0].path }}">
        <p>This browser does not support PDFs. You can view it <a href="{{ site.baseurl }}{{ cvs[0].path }}">here</a>.</p>
    </embed>
</object>
