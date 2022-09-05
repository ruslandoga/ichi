defmodule ConjTest do
  use I.DataCase, async: true

  def no_conj_data(_seq) do
    # TODO
    false
  end

  # TODO
  def id(conj) do
    conj.id
  end

  #   (defun get-conj-data (seq &optional from/conj-ids texts)
  #   "from/conj-ids can be either from which word to find conjugations or a list of conj-ids
  #    texts is a string or list of strings, if supplied, only the conjs that have src-map with this text will be collected
  # "
  #   (when (or (eql from/conj-ids :root) (no-conj-data seq))
  #     (return-from get-conj-data nil))
  #   (unless (listp texts)
  #     (setf texts (list texts)))
  #   (loop for conj in (cond
  #                       ((null from/conj-ids)
  #                        (select-dao 'conjugation (:= 'seq seq)))
  #                       ((listp from/conj-ids)
  #                        (select-dao 'conjugation (:and (:= 'seq seq) (:in 'id (:set from/conj-ids)))))
  #                       (t (select-dao 'conjugation (:and (:= 'seq seq) (:= 'from from/conj-ids)))))
  #      for src-map = (if texts
  #                        (query (:select 'text 'source-text :from 'conj-source-reading
  #                                        :where (:and (:= 'conj-id (id conj)) (:in 'text (:set texts)))))
  #                        (query (:select 'text 'source-text :from 'conj-source-reading
  #                                        :where (:= 'conj-id (id conj)))))
  #        when (or (not texts) src-map)
  #        nconcing (loop for prop in (select-dao 'conj-prop (:= 'conj-id (id conj)))
  #                      collect (make-conj-data :seq (seq conj) :from (seq-from conj)
  #                                              :via (let ((via (seq-via conj)))
  #                                                     (if (eql via :null) nil via))
  #                                              :prop prop
  #                                              :src-map src-map
  #                                              ))))

  def get_conj_data(seq, from_conj_ids, texts) do
    # (when (or (eql from/conj-ids :root) (no-conj-data seq))
    if from_conj_ids == :root or no_conj_data(seq) do
      # (return-from get-conj-data nil))
      # get_conj_data(nil)
      # TODO?
      []
    else
      # (unless (listp texts)
      #   (setf texts (list texts)))
      texts = List.wrap(texts)

      conj_q = "conjugation" |> where(seq: ^seq) |> select([c], [:id, :seq, :from, :via])

      conjugations =
        cond do
          # ((null from/conj-ids)
          is_nil(from_conj_ids) ->
            # (select-dao 'conjugation (:= 'seq seq)))
            Repo.all(conj_q)

          # ((listp from/conj-ids)
          is_list(from_conj_ids) ->
            # (select-dao 'conjugation (:and (:= 'seq seq) (:in 'id (:set from/conj-ids)))))
            conj_q |> where([c], c.id in ^from_conj_ids) |> Repo.all()

          # (t (select-dao 'conjugation (:and (:= 'seq seq) (:= 'from from/conj-ids)))))
          true ->
            conj_q |> where(from: ^from_conj_ids) |> Repo.all()
        end

      for conj <- conjugations do
        src_map =
          case texts do
            [] ->
              # (query (:select 'text 'source-text :from 'conj-source-reading
              #   :where (:= 'conj-id (id conj))))

              "conj_source_reading"
              |> where(conj_id: ^id(conj))
              |> select([c], [:text, :source_text])
              |> Repo.all()

            _not_empty ->
              nil
              # (query (:select 'text 'source-text :from 'conj-source-reading
              #   :where (:and (:= 'conj-id (id conj)) (:in 'text (:set texts)))))

              "conj_source_reading"
              |> where(conj_id: ^id(conj))
              |> where([c], c.text in ^texts)
              |> select([c], [:text, :source_text])
              |> Repo.all()
          end

        # when (or (not texts) src-map)
        if !texts or src_map do
          # nconcing (loop for prop in (select-dao 'conj-prop (:= 'conj-id (id conj)))
          #               collect (make-conj-data :seq (seq conj) :from (seq-from conj)
          #                                       :via (let ((via (seq-via conj)))
          #                                             (if (eql via :null) nil via))
          #                                       :prop prop
          #                                       :src-map src-map
          #                                       ))))

          props =
            "conj_prop"
            |> where(conj_id: ^id(conj))
            |> select([c], [:id, :conj_id, :conj_type, :pos, :neg, :fml])
            |> Repo.all()

          for prop <- props do
            %{
              seq: conj.seq,
              from: conj.from,
              via: conj.via || :null,
              prop: prop,
              src_map: src_map
            }
          end
        end
      end
    end
  end

  test "get_conj_data/3" do
    assert get_conj_data(10_000_054, nil, nil) == [
             [
               %{
                 from: 1_314_150,
                 prop: %{
                   conj_id: 56,
                   conj_type: 1,
                   fml: true,
                   id: 56,
                   neg: true,
                   pos: "v1"
                 },
                 seq: 10_000_054,
                 src_map: [
                   %{source_text: "事足りる", text: "事足りません"},
                   %{source_text: "ことたりる", text: "ことたりません"},
                   %{source_text: "こと足りる", text: "こと足りません"}
                 ],
                 via: :null
               }
             ],
             [
               %{
                 from: 1_314_160,
                 prop: %{
                   conj_id: 48970,
                   conj_type: 1,
                   fml: true,
                   id: 50060,
                   neg: true,
                   pos: "v5r"
                 },
                 seq: 10_000_054,
                 src_map: [
                   %{source_text: "事足る", text: "事足りません"},
                   %{source_text: "ことたる", text: "ことたりません"}
                 ],
                 via: :null
               }
             ]
           ]
  end
end
