import pandas as pd

from analysis import disease_summary


def test_disease_summary():

    df = pd.DataFrame(

        {
            "Disease": [
                "Measles",
                "Measles",
                "Flu"
            ]
        }

    )

    result = disease_summary(df)

    assert len(result) == 2