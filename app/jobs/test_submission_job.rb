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
      if status != :OK
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
        return :WA, strip_out(stdout)
      end
    rescue Timeout::Error
      return :TL, "Stdout:\n" + strip_out(stdout) + "\n\nStderr:\n" + stderr
    end
  end

  private

  def strip_out(output)
    if output.length > 230
      output[0, 230] + '...[OUTPUT STRIPPED]...'
    else
      output
    end
  end
end
