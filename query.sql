SELECT COUNT(package.id) AS count
FROM package, (
                SELECT DISTINCT pdt.package_id
                FROM
                  (

                    /* packages direkt: */
                    SELECT
                      package.id AS package_id,
                      dogtag.id  AS dogtag_id,
                      weight,
                      dogtag.global_score
                    FROM
                      package
                      , dogtag_knots
                      , dogtag
                    WHERE
                      package.id = dogtag_knots.object_id
                      AND
                      package.brand IN ('SMR')
                      AND
                      dogtag_knots.object_type = 'package'
                      AND
                      dogtag_knots.dogtag_id = dogtag.id
                      AND dogtag_id IN (
                        /* query_dogtag_and_score_by_object: */

                        SELECT dogtag_id
                        FROM topic
                          LEFT JOIN dogtag_knots AS dt
                            ON (topic.id = dt.object_id AND dt.object_type = 'topic')
                          LEFT JOIN dogtag
                            ON (dogtag.id = dt.dogtag_id)
                        WHERE 1
                              AND topic.id = '11'

                        /* :query_dogtag_and_score_by_object */
                      )
                      AND IF((
                               /* query_get_required_dogtag_ids_for_object(): */
                               SELECT count(dogtag_id) AS count
                               FROM dogtag_knots
                               WHERE required = 1
                                     AND weight > 0
                                     AND object_type = 'topic'
                                     AND object_id = '11'), /* packages with required dogtags */ package.id IN (
                        /* query_packages_with_required_dogtags_for_object(): */

                        SELECT package_id
                        FROM (

                               /* packages direkt: */
                               SELECT
                                 package.id AS package_id,
                                 dogtag.id  AS required_dogtag_id
                               FROM
                                 package
                                 , dogtag_knots
                                 , dogtag
                               WHERE
                                 package.id = dogtag_knots.object_id
                                 AND
                                 package.brand IN ('SMR')
                                 AND
                                 dogtag_knots.object_type = 'package'
                                 AND
                                 dogtag_knots.dogtag_id = dogtag.id
                                 AND /* required dogtags */ IF((
                                                                 /* query_get_required_dogtag_ids_for_object(): */
                                                                 SELECT count(dogtag_id) AS count
                                                                 FROM dogtag_knots
                                                                 WHERE required = 1
                                                                       AND weight > 0
                                                                       AND object_type = 'topic'
                                                                       AND object_id = '11'), (dogtag_id IN (
                                   /* query_get_required_dogtag_ids_for_object(): */
                                   SELECT dogtag_id
                                   FROM dogtag_knots
                                   WHERE required = 1
                                         AND weight > 0
                                         AND object_type = 'topic'
                                         AND object_id = '11') AND dogtag_knots.weight > 0), 1)
                               UNION

                               /* packages über hotel nach hundemarke: */
                               SELECT
                                 package.id AS package_id,
                                 dogtag.id  AS required_dogtag_id
                               FROM
                                 package
                                 , dogtag_knots
                                 , dogtag
                                 , object_object_knots
                               WHERE
                                 package.id = object_object_knots.object2_id
                                 AND
                                 package.brand IN ('SMR')
                                 AND
                                 object_object_knots.object2_type = "package"
                                 AND
                                 object_object_knots.object1_type = "hotel"
                                 AND
                                 object_object_knots.object1_id = dogtag_knots.object_id
                                 AND
                                 dogtag_knots.object_type = 'hotel'
                                 AND
                                 dogtag_knots.dogtag_id = dogtag.id AND /* required dogtags */ IF((
                                                                                                    /* query_get_required_dogtag_ids_for_object(): */
                                                                                                    SELECT count(
                                                                                                               dogtag_id) AS count
                                                                                                    FROM dogtag_knots
                                                                                                    WHERE required = 1
                                                                                                          AND weight > 0
                                                                                                          AND
                                                                                                          object_type =
                                                                                                          'topic'
                                                                                                          AND
                                                                                                          object_id =
                                                                                                          '11'),
                                                                                                  (dogtag_id IN (
                                                                                                    /* query_get_required_dogtag_ids_for_object(): */
                                                                                                    SELECT dogtag_id
                                                                                                    FROM dogtag_knots
                                                                                                    WHERE required = 1
                                                                                                          AND weight > 0
                                                                                                          AND
                                                                                                          object_type =
                                                                                                          'topic'
                                                                                                          AND
                                                                                                          object_id =
                                                                                                          '11') AND
                                                                                                   dogtag_knots.weight >
                                                                                                   0), 1)
                             ) AS t1
                        GROUP BY package_id
                        HAVING count(*) = (
                          /* query_get_required_count(dogtag_id)s_for_object(): */
                          SELECT count(dogtag_id)
                          FROM dogtag_knots
                          WHERE required = 1
                                AND weight > 0
                                AND object_type = 'topic'
                                AND object_id = '11')
                      ), 1)
                    UNION

                    /* packages über hotel nach hundemarke: */
                    SELECT
                      package.id AS package_id,
                      dogtag.id  AS dogtag_id,
                      weight,
                      dogtag.global_score
                    FROM
                      package
                      , dogtag_knots
                      , dogtag
                      , object_object_knots
                    WHERE
                      package.id = object_object_knots.object2_id
                      AND
                      package.brand IN ('SMR')
                      AND
                      object_object_knots.object2_type = "package"
                      AND
                      object_object_knots.object1_type = "hotel"
                      AND
                      object_object_knots.object1_id = dogtag_knots.object_id
                      AND
                      dogtag_knots.object_type = 'hotel'
                      AND
                      dogtag_knots.dogtag_id = dogtag.id AND dogtag_id IN (/* q_dogtags_by_object: */
                        /* query_dogtag_and_score_by_object: */

                        SELECT dogtag_id
                        FROM topic
                          LEFT JOIN dogtag_knots AS dt
                            ON (topic.id = dt.object_id AND dt.object_type = 'topic')
                          LEFT JOIN dogtag
                            ON (dogtag.id = dt.dogtag_id)
                        WHERE 1
                              AND topic.id = '11'

                        /* :query_dogtag_and_score_by_object */
                        /* :q_dogtags_by_object */)
                      AND IF((
                               /* query_get_required_dogtag_ids_for_object(): */
                               SELECT count(dogtag_id) AS count
                               FROM dogtag_knots
                               WHERE required = 1
                                     AND weight > 0
                                     AND object_type = 'topic'
                                     AND object_id = '11'), /* packages with required dogtags */ package.id IN (
                        /* query_packages_with_required_dogtags_for_object(): */

                        SELECT package_id
                        FROM (

                               /* packages direkt: */
                               SELECT
                                 package.id AS package_id,
                                 dogtag.id  AS required_dogtag_id
                               FROM
                                 package
                                 , dogtag_knots
                                 , dogtag
                               WHERE
                                 package.id = dogtag_knots.object_id
                                 AND
                                 package.brand IN ('SMR')
                                 AND
                                 dogtag_knots.object_type = 'package'
                                 AND
                                 dogtag_knots.dogtag_id = dogtag.id
                                 AND /* required dogtags */ IF((
                                                                 /* query_get_required_dogtag_ids_for_object(): */
                                                                 SELECT count(dogtag_id) AS count
                                                                 FROM dogtag_knots
                                                                 WHERE required = 1
                                                                       AND weight > 0
                                                                       AND object_type = 'topic'
                                                                       AND object_id = '11'), (dogtag_id IN (
                                   /* query_get_required_dogtag_ids_for_object(): */
                                   SELECT dogtag_id
                                   FROM dogtag_knots
                                   WHERE required = 1
                                         AND weight > 0
                                         AND object_type = 'topic'
                                         AND object_id = '11') AND dogtag_knots.weight > 0), 1)
                               UNION

                               /* packages über hotel nach hundemarke: */
                               SELECT
                                 package.id AS package_id,
                                 dogtag.id  AS required_dogtag_id
                               FROM
                                 package
                                 , dogtag_knots
                                 , dogtag
                                 , object_object_knots
                               WHERE
                                 package.id = object_object_knots.object2_id
                                 AND
                                 package.brand IN ('SMR')
                                 AND
                                 object_object_knots.object2_type = "package"
                                 AND
                                 object_object_knots.object1_type = "hotel"
                                 AND
                                 object_object_knots.object1_id = dogtag_knots.object_id
                                 AND
                                 dogtag_knots.object_type = 'hotel'
                                 AND
                                 dogtag_knots.dogtag_id = dogtag.id AND /* required dogtags */ IF((
                                                                                                    /* query_get_required_dogtag_ids_for_object(): */
                                                                                                    SELECT count(
                                                                                                               dogtag_id) AS count
                                                                                                    FROM dogtag_knots
                                                                                                    WHERE required = 1
                                                                                                          AND weight > 0
                                                                                                          AND
                                                                                                          object_type =
                                                                                                          'topic'
                                                                                                          AND
                                                                                                          object_id =
                                                                                                          '11'),
                                                                                                  (dogtag_id IN (
                                                                                                    /* query_get_required_dogtag_ids_for_object(): */
                                                                                                    SELECT dogtag_id
                                                                                                    FROM dogtag_knots
                                                                                                    WHERE required = 1
                                                                                                          AND weight > 0
                                                                                                          AND
                                                                                                          object_type =
                                                                                                          'topic'
                                                                                                          AND
                                                                                                          object_id =
                                                                                                          '11') AND
                                                                                                   dogtag_knots.weight >
                                                                                                   0), 1)
                             ) AS t1
                        GROUP BY package_id
                        HAVING count(*) = (
                          /* query_get_required_count(dogtag_id)s_for_object(): */
                          SELECT count(dogtag_id)
                          FROM dogtag_knots
                          WHERE required = 1
                                AND weight > 0
                                AND object_type = 'topic'
                                AND object_id = '11')
                      ), 1)
                  ) AS pdt
                  , (
                      /* query_dogtag_and_score_by_object: */

                      SELECT
                        topic.id                          AS topic_id,
                        topic.id,
                        topic.name,
                        dogtag_id,
                        required,
                        dogtag.name                       AS Hundemarke,
                        dt.weight                         AS weight,
                        (dogtag.global_score * dt.weight) AS score2
                      FROM topic
                        LEFT JOIN dogtag_knots AS dt
                          ON (topic.id = dt.object_id AND dt.object_type = 'topic')
                        LEFT JOIN dogtag
                          ON (dogtag.id = dt.dogtag_id)
                      WHERE 1
                            AND topic.id = '11'

                      /* :query_dogtag_and_score_by_object */
                    ) AS odt
                WHERE odt.dogtag_id = pdt.dogtag_id
                GROUP BY package_id
              ) AS package_score
WHERE package.id = package_score.package_id
