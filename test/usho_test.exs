defmodule UshoTest do
  use ExUnit.Case
  doctest Usho

  test "put url - get url" do
    assert {:ok, tag} =
             Usho.put_url(
               "https://www.google.com/search?q=hashid+elixir&oq=<%token%>&aqs=chrome..69i57j0.7639j0j9&sourceid=<%token2%>&ie=UTF-8"
             )

    assert {:ok, _url} = Usho.get_url(tag, %{})
  end

  test "put url - get url with params applied" do
    assert {:ok, tag} =
             Usho.put_url(
               "https://www.google.com/search?q=hashid+elixir&oq=<%token%>&aqs=chrome..69i57j0.7639j0j9&sourceid=<%token2%>&ie=UTF-8"
             )

    assert {:ok, "https://www.google.com/search?q=hashid+elixir&oq=xxx__1__xxx&aqs=chrome..69i57j0.7639j0j9&sourceid=xxx__2__xxx&ie=UTF-8"} = Usho.get_url(tag, %{"token"=>"xxx__1__xxx","token2"=>"xxx__2__xxx"})
  end
end
