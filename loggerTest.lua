local logging = require("xLogging")

local logger = logging.new("file", "trace", "testFile")
logger.clearFile()

logger.log("test", "trace")

