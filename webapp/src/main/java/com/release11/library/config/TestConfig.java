package com.release11.library.config;

import com.marklogic.client.DatabaseClient;
import com.marklogic.client.document.DocumentWriteOperation;
import com.marklogic.client.ext.helper.DatabaseClientProvider;
import com.marklogic.client.io.DocumentMetadataHandle;
import com.marklogic.client.io.StringHandle;
import com.marklogic.client.io.marker.AbstractWriteHandle;
import com.marklogic.client.io.marker.DocumentMetadataWriteHandle;
import com.marklogic.spring.batch.item.processor.MarkLogicItemProcessor;
import com.marklogic.spring.batch.item.writer.MarkLogicItemWriter;
import com.release11.library.functions.BatchFunctions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.batch.core.*;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.JobScope;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.core.launch.support.RunIdIncrementer;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.ItemReader;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.PropertySource;

import java.io.File;
import java.util.List;
import java.util.Scanner;

/**
 * com.release11.library.config.YourJobConfig.java - a Spring Batch configuration template that demonstrates ingesting data into MarkLogic.  This
 * job specification uses the MarkLogicBatchConfiguration that utilizes a MarkLogic implementation of a JobRepository.
 *
 * @author Scott Stafford
 * @version 1.4.0
 * @see EnableBatchProcessing
 * @see com.marklogic.spring.batch.config.MarkLogicBatchConfiguration
 * @see com.marklogic.spring.batch.config.MarkLogicConfiguration
 * @see com.marklogic.spring.batch.item.processor.MarkLogicItemProcessor
 * @see com.marklogic.spring.batch.item.writer.MarkLogicItemWriter
 */
@EnableBatchProcessing
@Import(value = {
        com.marklogic.spring.batch.config.MarkLogicBatchConfiguration.class,
        com.marklogic.spring.batch.config.MarkLogicConfiguration.class})
@PropertySource("classpath:job-test.properties")
public class TestConfig {

    protected final Logger logger = LoggerFactory.getLogger(getClass());

    // This is the bean label for the name of your Job.  Pass this label into the job_id parameter
    // when using the CommandLineJobRunner
    private final String JOB_NAME = "deployTest";

    /**
     * The JobBuilderFactory and Step parameters are injected via the EnableBatchProcessing annotation.
     *
     * @param jobBuilderFactory injected from the @EnableBatchProcessing annotation
     * @param step              injected from the step method in this class
     * @return Job
     */
    @Bean(name = JOB_NAME)
    public Job job(JobBuilderFactory jobBuilderFactory, Step step) {
        JobExecutionListener listener = new JobExecutionListener() {
            @Override
            public void beforeJob(JobExecution jobExecution) {
                logger.info("BEFORE JOB");
                jobExecution.getExecutionContext().putString("random", "yourJob123");
            }

            @Override
            public void afterJob(JobExecution jobExecution) {
                logger.info("AFTER JOB");
            }
        };

        return jobBuilderFactory.get(JOB_NAME)
                .start(step)
                .listener(listener)
                .incrementer(new RunIdIncrementer())
                .build();
    }

    /**
     * The StepBuilderFactory and DatabaseClientProvider parameters are injected via Spring.  Custom parameters must be annotated with @Value.
     *
     * @param stepBuilderFactory     injected from the @EnableBatchProcessing annotation
     * @param databaseClientProvider injected from the BasicConfig class
     * @param collections            This is an example of how user parameters could be injected via command line or a properties file
     * @return Step
     * @see DatabaseClientProvider
     * @see ItemReader
     * @see ItemProcessor
     * @see DocumentWriteOperation
     * @see MarkLogicItemProcessor
     * @see MarkLogicItemWriter
     */
    @Bean
    @JobScope
    public Step step(
            StepBuilderFactory stepBuilderFactory,
            DatabaseClientProvider databaseClientProvider,
            @Value("#{jobParameters['output_collections'] ?: 'yourJob'}") String[] collections,
            @Value("#{jobParameters['chunk_size'] ?: 20}") int chunkSize) {

        DatabaseClient databaseClient = databaseClientProvider.getDatabaseClient();

        ItemReader<File> reader = new ItemReader<File>() {
            int i = 0;
            List<File> files = BatchFunctions.listFileWithSubfolderFiles(new File(getClass().getClassLoader().getResource("tests").getFile()));

            @Override
            public File read() throws Exception {

                File xmlFile = i < files.size()? files.get(i) : null;
                i++;
                return xmlFile;
            }
        };

        //The ItemProcessor is typically customized for your Job.  An anoymous class is a nice way to instantiate but
        //if it is a reusable component instantiate in its own class
        MarkLogicItemProcessor<File> processor = new MarkLogicItemProcessor<File>() {

            @Override
            public DocumentWriteOperation process(File item) throws Exception {
                DocumentWriteOperation dwo = new DocumentWriteOperation() {

                    @Override
                    public OperationType getOperationType() {
                        return OperationType.DOCUMENT_WRITE;
                    }

                    @Override
                    public String getUri() {
                        System.out.println(item.getPath());
                        return "/" + item.getPath().substring(item.getPath().lastIndexOf("tests\\") + 6).replaceAll("\\\\", "/");
                    }

                    @Override
                    public DocumentMetadataWriteHandle getMetadata() {
                        DocumentMetadataHandle metadata = new DocumentMetadataHandle();
                        metadata.withCollections(collections);
                        return metadata;
                    }

                    @Override
                    public AbstractWriteHandle getContent()  {
                        StringBuilder result = new StringBuilder("");
                        try {
                            Scanner scanner = new Scanner(item);
                            while (scanner.hasNextLine()) {
                                result.append(scanner.nextLine()).append("\n");

                            }

                            scanner.close();
                        } catch (Exception e)
                        {
                            e.printStackTrace();
                        }
                        return new StringHandle(result.toString());
                    }

                    @Override
                    public String getTemporalDocumentURI() {
                        return null;
                    }
                };
                return dwo;
            }
        };

        MarkLogicItemWriter writer = new MarkLogicItemWriter(databaseClient);
        writer.setBatchSize(chunkSize);


        ChunkListener chunkListener = new ChunkListener() {

            @Override
            public void beforeChunk(ChunkContext context) {
                logger.info("beforeChunk");
            }

            @Override
            public void afterChunk(ChunkContext context) {
                logger.info("afterChunk");
            }

            @Override
            public void afterChunkError(ChunkContext context) {

            }
        };

        return stepBuilderFactory.get("step1")
                .<File, DocumentWriteOperation>chunk(chunkSize)
                .reader(reader)
                .processor(processor)
                .writer(writer)
                .listener(chunkListener)
                .build();
    }

}