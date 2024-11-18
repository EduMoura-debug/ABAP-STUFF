#Tipos de View

##Database View (SE11)

Database views are implement an inner join, that is, only records of the primary table (selected via the join operation) for which the corresponding records of the secondary tables also exist are fetched. Inconsistencies between primary and secondary table could, therefore, lead to a reduced selection set.

In database views, the join conditions can be formulated using equality relationships between any base fields. In the other types of view, they must be taken from existing foreign keys. That is, tables can only be collected in a maintenance or help view if they are linked to one another via foreign keys.

##Help View ( SE54)

Help views are used to output additional information when the online help system is called.

When the F4 button is pressed for a screen field, a check is first made on whether a matchcode is defined for this field. If this is not the case, the help view is displayed in which the check table of the field is the primary table. Thus, for each table no more than one help view can be created, that is, a table can only be primary table in at most one help view.

##Projection View

Projection views are used to suppress or mask certain fields in a table (projection), thus minimizing the number of interfaces. This means that only the data that is actually required is exchanged when the database is accessed.

A projection view can draw upon only one table. Selection conditions cannot be specified for projection views.

##Maintenance View ( SE54 )

Maintenance views enable a business-oriented approach to looking at data, while at the same time, making it possible to maintain the data involved. Data from several tables can be summarized in a maintenance view and maintained collectively via this view. That is, the data is entered via the view and then distributed to the underlying tables by the system.