# On Rights

Or: your open-source project is a legal minefield, and fixing that is counterintuitive and unpopular.

The standard approach to releasing an open-source project in this age is to throw your code up on Github with a `LICENSE` file describing the terms under which other people may copy and distribute the project and its derived works. This is all well and good: when you write code for yourself, you generally hold the copyright to that code, and you can license it out however you see fit.

However, Github encourages projects to accept contributions. Pull request activity is, rightly or wrongly, considered a major indicator of project health by the Github community at large. Moreover, each pull request represents a gift of time and labour: projects without a clear policy otherwise are often in no position to reject such a gift unless it has clear defects.

This is a massive problem. The rights to contributed code are, generally, owned by the contributor, and not by the project's original authors, and a pull request, on its own, isn't anywhere near adequate to transfer those rights to the project maintainers.

Intuitively, it may seem like a good idea for each contributor to retain the rights to their contributions. There is a good argument that by contributing code with the intent that it be included in the published project, the contribution is under the same license as the project as a whole, and withholding the rights can effectively prevent the project from ever switching to a more-restrictive license without the contributor's consent.

However, it also cripples the project's legal ability to enforce the license. Someone distributing the project in violation of the license terms is infringing on all of those individual copyrights, and no contributor has obvious standing to bring suit on behalf of any other. Suing someone for copyright infringement becomes difficult: anyone seeking to bring suit either needs to restrict the suit to the portions they hold the copyright to (difficult when each contribution is functionally intertangled with every other), or obtain permission from all of the contributors, including those under pseudonyms or who have _died_, to file suit collectively. This, in turn, de-fangs whatever restrictions the license nominally imposes.

There are a few fixes for this.

The simplest one, from an implementation perspective, is to require that contributors agree in writing to assign the rights to their contribution to the project's maintainers, or to an organization. _This is massively unpopular_: asking a developer to give up rights to their contributions tends to provoke feelings that the project wants to take without giving, and the rationale justifying such a request isn't obvious without a grounding in intellectual property law. As things stand, the only projects that regularly do this are those backed by major organizations, as those organizations tend to be more sensitive to litigation risk and have the resources to understand and demand such an assignment. (Example: [the Sun Contributor Agreement](https://www.openoffice.org/licenses/sca.pdf), which is not popular.)

More complex - too complex to do without an attorney, honestly - is to require that contributors sign an agreement authorizing the project's maintainers or host organization to bring suit on their behalf with respect to their contributions. As attorneys are not free and as there are no "canned" agreements for this, it's not widely done. I anticipate that it might provoke a lot of the same reactions, but it does leave contributors nominally in possession of the rights to their work.

The status quo is, I think, untenable in the long term. We've already seen major litigation over project copyrights, and in the case of the [FSF v. Cisco](https://www.fsf.org/licensing/complaint-2008-12-11.pdf), the Free Software Foundation was fortunate that substantial parts of the infringing use were works to which the FSF held clear copyrights.
