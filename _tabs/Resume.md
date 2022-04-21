---
title: Resume
order: 1
icon: fas fa-user
---

{% assign resumes = site.static_files | where_exp: "file", "file.basename contains 'Resume'" %}

[View Original]({{ resumes[0].path }})
Last Updated: {{ resumes[0].modified_time }}

<object data="{{ resumes[0].path }}" type="application/pdf" width="100%" height=700px>
    <embed src="{{ resumes[0].path }}">
        <p>This browser does not support PDFs. You can view it <a href="{{ site.baseurl }}{{ resumes[0].path }}">here</a>.</p>
    </embed>
</object>
