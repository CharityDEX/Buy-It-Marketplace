package it.eat.back.config;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.autoconfigure.flyway.FlywayDataSource;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;

/**
 * Configuration Datasource for application
 */
@Configuration
public class DatabaseMySQLConfig {


    /**
     * Datasource creator
     * @return DataSource object for aplication
     */
    @Bean
    @FlywayDataSource
    @Qualifier("mainDataSource")
    @ConfigurationProperties(prefix = "spring.datasource")
    public DataSource mainDataSource() {
        return DataSourceBuilder.create().build();
    }

    /**
     * JDBCOperation creator
     * @param mainDataSource Datasource object linked to application
     * @return JDBCOperation object for application
     */
    @Bean
    @Qualifier("mainJdbcOperations")
    public JdbcOperations mainJdbcOperations(
            @Qualifier("mainDataSource")
                    final DataSource mainDataSource
    ) {
        return new JdbcTemplate(mainDataSource);
    }
}
