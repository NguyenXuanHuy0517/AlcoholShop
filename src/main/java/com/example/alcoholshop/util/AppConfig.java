package com.example.alcoholshop.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.InputStream;
import java.util.Properties;

public final class AppConfig {
    private static final Logger logger = LoggerFactory.getLogger(AppConfig.class);
    private static final Properties props = new Properties();

    static {
        try (InputStream in = AppConfig.class.getClassLoader().getResourceAsStream("application.properties")) {
            if (in != null) {
                props.load(in);
            } else {
                logger.warn("application.properties not found on classpath");
            }
        } catch (Exception e) {
            logger.error("Failed to load application.properties", e);
        }
    }

    private AppConfig() {}

    public static String get(String key) {
        String env = System.getenv(key.replace('.', '_').toUpperCase());
        if (env != null) return env;
        return props.getProperty(key);
    }

    public static String getOrDefault(String key, String defaultValue) {
        String v = get(key);
        return v != null ? v : defaultValue;
    }
}

