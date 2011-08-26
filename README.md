# CarbonFin Outliner Online Ruby Class/Scripts

A class and some Ruby utility scripts to interact with CarbonFin Outliner Online.

Please note that CFOO has not endorsed an official API and so these scripts are strictly _unofficial_ (but they work well and are likely to continue doing so).

They are useful as an interim measure until the CFO dev can introduce Dropbox syncing.

## Utility Scripts

First, add your username and password to login.rb.

Log in with:

    ./login.rb

Download with:

    ./download.rb <format> <name>

Upload OPML files with:

    ./upload.rb <file0.opml> <file1.opml> <file2.opml> ...

Upload plain text with:

    cat file | ./upload_text.rb <name> (<are_tasks>)


## The Class

The class isn't documented here, but it is largely self-explanatory and can be quickly understood by reading {download, upload, upload_text}.rb