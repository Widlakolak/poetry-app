package com.poetryapp.backend.catalog.repository;

import java.util.UUID;

import com.poetryapp.backend.catalog.domain.Creator;
import com.poetryapp.backend.catalog.domain.CreatorRole;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface CreatorRepository extends JpaRepository<Creator, UUID> {

    @Query(
            value = """
                    select distinct creator
                    from Creator creator
                    join creator.credits credit
                    where credit.creditRole = :role
                    order by creator.displayName
                    """,
            countQuery = """
                    select count(distinct creator.id)
                    from Creator creator
                    join creator.credits credit
                    where credit.creditRole = :role
                    """)
    Page<Creator> findAllByRole(@Param("role") CreatorRole role, Pageable pageable);
}
