import meta.utils.logger;

int main(string[] args) {
    logger.inst().info("Hello, world");
    logger.inst().deb("This is a debug line");
    logger.inst().warning("This is a warning line");
    logger.inst().error("This is an error line");

    /* formatted line test */
    logger.inst().deb("The serial number is %d", 314);
    return 0;
}