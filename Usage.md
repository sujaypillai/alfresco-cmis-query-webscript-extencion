# Usage #


> This module is started by a simple webscript call. You can know more about in the webscript definition browsing the follow URL:

> http://{host}:{port}/alfresco/service/script/org/alfresco/cmis/query.get

> where:
    * **{host}:** is the host of your instalation.
    * **{port}:** is the port used by Alfresco.


## Browsing Query ##

> One of way to use this extencion is call webscript using a browser. To call this webscript you can use this simple query:

> http://{host}:{port}/alfresco/service/cmis/query?q={query}&format={format?}

> where:
    * **{host}:** is the host of your instalation.
    * **{port}:** is the port used by Alfresco.
    * **{query}:** is a CMIS query.
    * **{format?}:** is a format that you can your response. This parameter is not requested and by default is **atomfeed**. It's can use 3 values:
      * **atomfeed:** outupt in atomfeed format.
      * **xml:** outupt in atomfeed format.
      * **json:** outupt in atomfeed format.

> As this extension uses an existing webscript this extends their functionalities. In this query many others parameters can be used, It's can be related bellow:

  * TODO