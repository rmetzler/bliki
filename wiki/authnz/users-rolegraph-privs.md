# A Users, Roles & Privileges Scheme Using Graphs

The basic elements:

* Every agent that can interact with a system is represented by a **user**.
* Every capability the system has is authorized by a distinct **privilege**.
* Each user has a list of zero or more **roles**.
    * Roles can **imply** further roles. This relationship is transitive: if
      role A implies role B, then a member of role A is a member of role B; if
      role B also implies role C, then a member of role A is also a member of
      role C. It helps if the resulting role graph is acyclic, but it's not
      necessary.
    * Roles can **grant** privileges.

A user's privileges are the union of the privileges granted by the transitive
closure of their roles.

## In SQL

    create table "user" (
        username varchar
            primary key
        -- credentials &c
    );
    
    create table role (
        name varchar
            primary key
    );
    
    create table role_member (
        role varchar
            not null
            references role,
        member varchar
            not null
            references "user",
        primary key (role, member)
    );
    
    create table role_implies (
        role varchar
            not null
            references role,
        implied_role varchar
            not null
    );
    
    create table privilege (
        privilege varchar
            primary key
    );
    
    create table role_grants (
        role varchar
            not null
            references role,
        privilege varchar
            not null
            references privilege,
        primary key (role, privilege)
    );

If your database supports recursive CTEs, querying this isn't awful, since we
can have the database do all the graph-walking along roles:

    with recursive user_roles (role) AS (
        select
            role
        from
            role_member
        where
            member = 'SOME USERNAME'
        union
        select
            implied_role as role
        from
            user_roles
            join role_implies on
                user_roles.role = role_implies.role
    )
    select distinct
        role_grants.privilege as privilege
    from
        user_roles
        join role_grants on
            user_roles.role = role_grants.role
    order by privilege;

If not, get a better database. Recursive graph walking with network round
trips at each step is stupid and you shouldn't do it.

Realistic uses should have fairly simple graphs: elemental privileges are
grouped into abstract roles, which are in turn grouped into meaningful roles
(by department, for example), which are in turn granted to users. In
PostgreSQL, the above schema handles ~10k privileges and ~10k roles with
randomly-generated graph relationships in around 100ms on my laptop, which is
pretty slow but not intolerable. Perverse cases (interconnected total
subgraphs, deeply-nested linear graphs) can take absurd time but do not
reflect any likely permissions scheme.

## What Sucks

* Graph theory in my authorization system? It's more likely than you think.
* There's no notion of revoking a privilege. If you have a privilege by any
  path through your roles, then it cannot be revoked except by removing all of
  the paths that lead back to that privilege.
* Not every system has an efficient way to compute these graphs.
    * PostgreSQL, as given above, has a hard time with unrealistically-deep
      nested roles.
