drop table if exists temp_hints;

create table temp_hints as
select p.id, count(hi.id) from problems p 
left outer join tutor_strategies tu on p.id = tu.problem_id
left outer join hints hi on tu.id = hi.tutor_strategy_id
where tu.content_type = 'Hint'
group by p.id;

drop table if exists temp_data;

create table temp_data as 
select pl.id as order_id, pl.assignment_id, pl.user_id as user_id, pl.assistment_id as assistment_id, pl.problem_id as problem_id, pl.original as original, pl.correct, pl.attempt_count, pl.first_response_time as ms_first_response, pl.tutor_mode, pt.name as answer_type, ca.sequence_id, ca.student_class_id, ca.position, s2.type,
case when si.copied_from is null then ca.sequence_id else si.copied_from end as base_sequence_id, tc.teacher_id, ur.location_id as school_id, pl.hint_count, temp.count as hint_total, pl.start_time, pl.overlap_time, CASE WHEN a.parent_id is null THEN pl.assistment_id ELSE a.parent_id END as template_id, pl.answer_id, pl.answer_text, pl.first_action, pl.bottom_hint
from problem_logs pl
left outer join problems p on pl.problem_id = p.id
left outer join temp_hints temp on p.id = temp.id
left outer join problem_types pt on p.problem_type_id = pt.id
left outer join class_assignments ca on pl.assignment_id =  ca.id
left outer join sequences s on ca.sequence_id = s.id
left outer join sections s2 on s.head_section_id = s2.id
left outer join sequence_infos si on ca.sequence_id = si.sequence_id
left outer join teacher_classes tc on tc.student_class_id = ca.student_class_id
left outer join student_classes sc on sc.id = ca.student_class_id
left outer join user_roles ur on ur.user_id = pl.user_id
left outer join assistment_infos a on pl.assistment_id = a.assistment_id
where
ca.student_class_id is not null and
ur.type = 'Student' and ur.location_type = 'School' and

--(extract(year from start_time) >= 2009 and extract(year from start_time) <2015)
((extract(year from start_time) = 2013 and extract(month from start_time) >8)
or (extract(year from start_time) = 2014 and extract(month from start_time) <9))
and pl.correct is not null
and s2.type = 'MasterySection'
and ca.assignment_type_id not in (6, 7) 
--and ca.sequence_id in (11893) --10265,6921,10195,11898,11829,
order by pl.id, pl.user_id;

select distinct on (order_id) order_id, assignment_id, user_id, assistment_id, problem_id, original, correct, attempt_count, sequence_id,student_class_id,
teacher_id, school_id, hint_count, hint_total, first_action, ms_first_response
 from temp_data where tutor_mode='tutor' and hint_total>0

select user_id from temp_data limit 10


SELECT
 --XXXXX
 --used to join tables only, do not includ in report, refer to problem_logs.user_id
 user_id AS problem_logs_user_id_x,
 --XXXXX
 SUM(original) AS prior_correctness_prior_problem_count,
 SUM(correct) AS prior_correctness_prior_correct_count,
 SUM(correct)/SUM(original) AS prior_correctness_prior_percent_correct

 FROM problem_logs
 WHERE original = 1 AND end_time IS NOT NULL
 AND assignment_id <
 (
  -- find the very first problem log entry for all the assignments from this sequence (problem set)
  SELECT MIN(assignment_id)
  FROM problem_logs
  WHERE problem_logs.assignment_id IN
  (
   -- the same sequence (problem set) could be assigned to same or different students multiple times
   -- each assginement will generate a assignment_id in class_assignments table
   SELECT id
   FROM class_assignments
   WHERE sequence_id IN (?)
  )
 )
 GROUP BY user_id
 ORDER BY user_id ASC


 (extract(year from start_time) = 2012 and extract(month from start_time) >8)
or 




 select * from problems where assistment_id = 231085

 select * from tutor_strategies where problem_id=220747

 select * from hints where tutor_strategy_id=160765

 select * from problems where id = 220747

 select * from problem_logs where user_id = 82210 and problem_id = 220747

 select * from sequences where id = 11893
