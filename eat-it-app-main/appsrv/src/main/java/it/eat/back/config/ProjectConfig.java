package it.eat.back.config;

import it.eat.back.core.database.PGJournal;
import it.eat.back.core.dbinterface.IDBJournal;
import it.eat.back.core.dbinterface.IDBRepository;
import it.eat.back.core.database.PGRepository;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.core.io.FileSystemResource;
import org.springframework.jdbc.core.JdbcOperations;

/**
 * Project configuration
 */
@Configuration
public class ProjectConfig {
    /**
     * project configuration
     * @param jdbcOperations JdbcOperation object
     * @return db controller object
     */
    @Bean
    public IDBRepository idbController(final JdbcOperations jdbcOperations) {
        return new PGRepository(jdbcOperations);
    }

    /**
     * journal configuration
     * @param jdbcOperations JdbcOperation object
     * @return PGJournal object
     */
    @Bean
    public IDBJournal idbJournalController(final JdbcOperations jdbcOperations) {
        return new PGJournal(jdbcOperations);
    }
    /**
     * Set project configuration
     * @return property configuration file location
     */
    @Bean
    public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
        PropertySourcesPlaceholderConfigurer properties =
                new PropertySourcesPlaceholderConfigurer();
        properties.setLocation(new FileSystemResource("application.yml"));
        properties.setIgnoreResourceNotFound(false);
        return properties;
    }
}
