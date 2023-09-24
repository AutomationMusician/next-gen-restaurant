// const fs = require('fs');
const fs = require('node:fs/promises');

const output = [];

async function main() {
    const raw_data_contents = await fs.readdir(__dirname + "/raw_data");
    for (let i=0; i<raw_data_contents.length; i++)
    {
        const filename = raw_data_contents[i];
        const tableName = getTableName(filename);
        const lines = (await fs.readFile(__dirname + "/raw_data/" + filename)).toString().split("\n");
        const header = `INSERT INTO ${tableName} (${lines[0]}) VALUES`;
        for (let j=1; j<lines.length; j++)
        {
            output.push(`${header} (${splitCells(lines[j]).join(", ")});`);
        }
        output.push('');
    };

    await fs.writeFile(__dirname + "/insert-data.sql", output.join('\n'));
}

function getTableName(filename)
{
    return filename.replace(/(.*)_/,'').replace('.csv', '');
}

function splitCells(line)
{
    const cells = [];
    let inQuotes = false
    let startIndex = 0;
    for (let i=0; i<line.length; i++)
    {
        const char = line.charAt(i);
        if (!inQuotes)
        {
            if (char === '"')
            {
                inQuotes = true;
                // assume this is the first element of the cell and ignore this quote
                startIndex++;
            }
            else if (char === ",")
            {
                cells.push(line.substring(startIndex,i));
                startIndex = i+1;
            }
        }
        else
        {
            if (char === '"')
            {
                inQuotes = false;
                // assume this is the last element of the cell. Skip over the following comma
                cells.push(line.substring(startIndex,i));
                i++;
                startIndex = i+1;
            }
        }
    }
    if (startIndex < line.length) {
        cells.push(line.substring(startIndex));
    }
    return cells;
}

main();