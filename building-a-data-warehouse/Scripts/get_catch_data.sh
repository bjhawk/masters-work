# iterate through the EEZ ids and get the catch data
i=1
while read eez; do
    # In case anything happens, or the script runtime is too long
    # to be done in one go, this if condition makes it restart-safe
    if [[ ! -f "../Data/$eez.zip" ]]
    then
        echo "Downloading file $i of 281. . ."
        curl "https://api.seaaroundus.org/api/v1/eez/tonnage/taxon/?format=csv&limit=10&sciname=&region_id=$eez" --output "../Data/$eez.zip"

        datafilename="SAU EEZ $eez v48-0.csv"
        echo "Unzipping data file. . ."
        unzip -p "../Data/$eez.zip" "$datafilename" > "../Data/$eez.csv"

        # A "good faith" attempt to limit stress on their undocumented API
        # It would take up to a minute to navigate to the next page manually
        # so even automated, this is actually LESS load on their systems
        # with this sleep timer here.
        sleep 1m
    else
        echo "File already exists!"
    fi
    echo ""
    i=$((i+1))
done < ../Data/eezids.txt