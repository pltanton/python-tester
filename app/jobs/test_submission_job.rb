class TestSubmissionJob < ApplicationJob
  queue_as :default

  def perform(submission)
    test_solution submission
  end

  protected

  def test_solution(submission)
    ok = true
    number_of_test = 1
    Test.where(task: submission.task).each do |test|
      status, output = test_solution_unit test, submission
      case status
      when :TL
        submission.update status: "TL ##{number_of_test}",
                          bad_test_id: test.id
        ok = false
        break
      when :WA, :SE
        submission.update status: "#{status} ##{number_of_test}",
                          bad_test_id: test.id,
                          bad_out: output.to_s
        puts st
        ok = false
        break
      end
      number_of_test += 1
    end
    submission.update status: 'OK' if ok
  end

  def test_solution_unit(test, submission)
    begin
      stdout = ''
      stderr = ''
      status = open4.spawn(
        "python -c #{Shellwords.escape submission.solution}",
        timeout: 3,
        stdout: stdout,
        stderr: stderr,
        stdin: test.in
      )

      if status.exitstatus != 0 || !stderr.empty?
        return :SE, stderr
      elsif stdout.squish == test.out.squish
        :OK
      else
        return :WA, stdout
      end
    rescue Timeout::Error
      :TL
    end
  end
end
