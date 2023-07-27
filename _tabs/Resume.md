---
title: Resume
order: 2
icon: fas fa-user
---

{% assign resumes = site.static_files | where_exp: "file", "file.basename contains 'Resume'" %}

[Download File]({{ resumes[0].path }})
(Last Updated: {{ resumes[0].modified_time | date: "%Y-%m-%d" }})

<object data="{{ resumes[0].path }}" type="application/pdf" width="100%" height=700px>
    <embed src="{{ resumes[0].path }}">
        <p>This browser does not support PDFs. You can view it <a href="{{ site.baseurl }}{{ resumes[0].path }}">here</a>.</p>
    </embed>
</object>
