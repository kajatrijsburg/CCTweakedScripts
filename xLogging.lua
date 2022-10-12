local utils = require("xLuaUtils")

local xLogging = {}

local loggingDir = "logs/"

local validLoggingModes = {
    term = true,
    file = true,
    none = true
}

local loggingLevelsMap = {
    none = 1,
    fatal = 2,
    error = 3,
    trace = 4
}

local validLoggingLevels = {}
validLoggingLevels[1] = true --none
validLoggingLevels[2] = true --fatal
validLoggingLevels[3] = true --error
validLoggingLevels[4] = true -- trace

function xLogging.new(mode, level, outputFile)
    --if  the logging level is given as a string, convert it to a number
    if type(level) == "string" then
        level = loggingLevelsMap[level]
    end

    --validade the given arguments 
    assert(validLoggingModes[mode] == true, mode .. " is not a valid mode for the logger. Valid loggin' modes are: term, file, none")
    assert(validLoggingLevels[level] == true, level .. " is not a valid logging level. Valid logging levels are: trace (4), error (3), fatal (2), none (1)")
    utils.assertString(outputFile)

    --create a new logger
    local logger = {
        mode = mode,
        outputFile = outputFile,
        level = level
    }

    --add setters and getters
    function logger.setLoggingMode(loggingMode)
        assert(validLoggingModes[loggingMode] ~= true, loggingMode .. " is not a valid mode for the loggin class. Valid loggin modes are: term, file, none")
        logger.mode = loggingMode
    end

    function logger.setOutputFile(file)
        utils.assertString(outputFile)
        logger.outputFile = file
    end

    function logger.getLoggingMode()
        return logger.mode
    end

    function logger.getOutputFile()
        return logger.outputFile
    end

    function logger.clearFile()
        local file = fs.open(loggingDir .. logger.outputFile .. ".txt", "w")
	    file.write()
	    file.close()
    end
    --log a message
    function logger.log(message, messageLevel)
        --if the message level is provided as a string, map it to the appropriate number
        if type(messageLevel) == "string" then
            messageLevel = loggingLevelsMap[messageLevel]
        end

        utils.assertNumber(messageLevel)

        --check if we need to do anything with the meesage at all

        --if the message level is not low enough, return
        if messageLevel > logger.level then return end
        
        -- if logging mode is set to none, return
        if logger.mode == "none" then return end

        --if the mode is set to term, just dump the message on the terminal
        if logger.mode == "term" then
            print(message)
        end

        --if the mode is set to file, then write the message to a file with the time
        if logger.mode == "file" then
            message = os.clock() .. ": " .. message
            
            local file = fs.open(loggingDir .. logger.outputFile .. ".txt", "a")
		    file.write(message .. "\n")
		    file.close()
        end

    end

    return logger
end


return xLogging