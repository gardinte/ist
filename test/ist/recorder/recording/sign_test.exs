defmodule Ist.Recorder.Recording.SignTest do
  use Ist.DataCase, async: true

  describe "sign" do
    test "signed url" do
      {:ok, recording, _account} = fixture(:recording)

      assert Ist.Recorder.Recording.Sign.signed_url(recording) =~ recording.file
    end
  end
end
