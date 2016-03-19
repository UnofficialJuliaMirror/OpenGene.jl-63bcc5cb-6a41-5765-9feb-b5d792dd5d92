function opengene_homedir()
    dir = homedir() * "/.OpenGene"
    if !isdir(dir)
        try
            mkdir(dir)
        catch(e)
            error("Cannot create folder $dir")
        end
    end
    return dir
end

function parse_config()
    homedir = opengene_homedir()
    file = "$homedir/config.ini"
    config = Dict()
    if !isfile(file)
        return config
    end
    io = open(file)
    text = readall(io)
    lines = split(text, '\n')
    for line in lines
        line = strip(line)
        if length(line) < 3
            continue
        end
        items = split(line, '=')
        if length(items) < 2
            warn("error format of $line")
            warn("each line in the config file should have format key = value")
            continue
        end
        key = strip(items[1])
        value = strip(items[2])
        config[key] = value
    end
    return config
end

function opengene_datadir()
    config = parse_config()
    dir = opengene_homedir() * "/data"
    if haskey(config, "data_folder")
        dir = config["data_folder"]
    end
    if !isdir(dir)
        try
            mkdir(dir)
        catch(e)
            error("Cannot create folder $dir")
        end
    end
    return dir
end