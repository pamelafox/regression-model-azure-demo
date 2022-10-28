from enum import Enum

import azure.functions
import fastapi
import joblib
import nest_asyncio
import numpy

app = fastapi.FastAPI()

nest_asyncio.apply()

# import enums

# todo: categorical transformer?
# or I could just do a smarter version of what I originally did
# as

class EducationLevel(str, Enum):
    MS = "Master’s degree (M.A., M.S., M.Eng., MBA, etc.)"
    BS = "Bachelor’s degree (B.A., B.S., B.Eng., etc.)"
    SS = "Secondary school (e.g. American high school, German Realschule or Gymnasium, etc.)"
    SO = "Something else"
    AS = "Associate degree (A.A., A.S., etc.)"
    DO = "Some college/university study without earning a degree"
    MD = "Professional degree (JD, MD, etc.)"
    DD = "Other doctoral degree (Ph.D., Ed.D., etc.)"
    ES = "Primary/elementary school"


class Country(str, Enum):
    UNITED_KINGDOM = "United Kingdom of Great Britain and Northern Ireland"
    ISRAEL = "Israel"
    NETHERLANDS = "Netherlands"
    UNITED_STATES_OF_AMERICA = "United States of America"
    CZECH_REPUBLIC = "Czech Republic"
    AUSTRIA = "Austria"
    ITALY = "Italy"
    CANADA = "Canada"
    GERMANY = "Germany"
    POLAND = "Poland"
    MADAGASCAR = "Madagascar"
    NORWAY = "Norway"
    TAIWAN = "Taiwan"
    FRANCE = "France"
    BRAZIL = "Brazil"
    URUGUAY = "Uruguay"
    SWEDEN = "Sweden"
    SPAIN = "Spain"
    TURKEY = "Turkey"
    ROMANIA = "Romania"
    INDIA = "India"
    BELGIUM = "Belgium"
    BULGARIA = "Bulgaria"
    GREECE = "Greece"
    SAUDI_ARABIA = "Saudi Arabia"
    KENYA = "Kenya"
    SWITZERLAND = "Switzerland"
    LATVIA = "Latvia"
    IRELAND = "Ireland"
    SOUTH_AFRICA = "South Africa"
    THAILAND = "Thailand"
    CHINA = "China"
    MONTENEGRO = "Montenegro"
    FINLAND = "Finland"
    SLOVAKIA = "Slovakia"
    JAPAN = "Japan"
    DENMARK = "Denmark"
    AUSTRALIA = "Australia"
    VIET_NAM = "Viet Nam"
    PORTUGAL = "Portugal"
    ARGENTINA = "Argentina"
    HUNGARY = "Hungary"
    TUNISIA = "Tunisia"
    BANGLADESH = "Bangladesh"
    UKRAINE = "Ukraine"
    MALDIVES = "Maldives"
    HONG_KONG = "Hong Kong (S.A.R.)"
    RUSSIAN_FEDERATION = "Russian Federation"
    MEXICO = "Mexico"
    EGYPT = "Egypt"
    SERBIA = "Serbia"
    SINGAPORE = "Singapore"
    PAKISTAN = "Pakistan"
    NEPAL = "Nepal"
    CROATIA = "Croatia"
    INDONESIA = "Indonesia"
    BOSNIA_AND_HERZEGOVINA = "Bosnia and Herzegovina"
    ARMENIA = "Armenia"
    IRAN = "Iran, Islamic Republic of..."
    BELARUS = "Belarus"
    COSTA_RICA = "Costa Rica"
    LITHUANIA = "Lithuania"
    MAURITIUS = "Mauritius"
    ESTONIA = "Estonia"
    KAZAKHSTAN = "Kazakhstan"
    MOROCCO = "Morocco"
    CHILE = "Chile"
    SLOVENIA = "Slovenia"
    NEW_ZEALAND = "New Zealand"
    ECUADOR = "Ecuador"
    CYPRUS = "Cyprus"
    PHILIPPINES = "Philippines"
    PERU = "Peru"
    AFGHANISTAN = "Afghanistan"
    NICARAGUA = "Nicaragua"
    ANDORRA = "Andorra"
    REPUBLIC_OF_KOREA = "Republic of Korea"
    COLOMBIA = "Colombia"
    LEBANON = "Lebanon"
    SOUTH_KOREA = "South Korea"
    MALAYSIA = "Malaysia"
    SRI_LANKA = "Sri Lanka"
    GUATEMALA = "Guatemala"
    JORDAN = "Jordan"
    AZERBAIJAN = "Azerbaijan"
    UNITED_ARAB_EMIRATES = "United Arab Emirates"
    NIGERIA = "Nigeria"
    UZBEKISTAN = "Uzbekistan"
    ETHIOPIA = "Ethiopia"
    LUXEMBOURG = "Luxembourg"
    MACEDONIA = "The former Yugoslav Republic of Macedonia"
    SYRIAN_ARAB_REPUBLIC = "Syrian Arab Republic"
    CAMBODIA = "Cambodia"
    FIJI = "Fiji"
    ALBANIA = "Albania"
    MONGOLIA = "Mongolia"
    REPUBLIC_OF_MOLDOVA = "Republic of Moldova"
    TAJIKISTAN = "Tajikistan"
    TIMOR_LESTE = "Timor-Leste"
    GHANA = "Ghana"
    UNITED_REPUBLIC_OF_TANZANIA = "United Republic of Tanzania"
    ALGERIA = "Algeria"
    CAMEROON = "Cameroon"
    KOSOVO = "Kosovo"
    GEORGIA = "Georgia"
    TURKMENISTAN = "Turkmenistan"
    BOTSWANA = "Botswana"
    MYANMAR = "Myanmar"
    PALESTINE = "Palestine"
    SENEGAL = "Senegal"
    DOMINICAN_REPUBLIC = "Dominican Republic"
    RWANDA = "Rwanda"
    MALTA = "Malta"
    VENEZUELA = "Venezuela, Bolivarian Republic of..."
    CUBA = "Cuba"
    KUWAIT = "Kuwait"
    EL_SALVADOR = "El Salvador"
    BOLIVIA = "Bolivia"
    ISLE_OF_MAN = "Isle of Man"
    HONDURAS = "Honduras"
    MALI = "Mali"
    PANAMA = "Panama"
    LAO = "Lao People's Democratic Republic"
    ICELAND = "Iceland"
    BAHRAIN = "Bahrain"
    PARAGUAY = "Paraguay"
    UGANDA = "Uganda"
    DEMOCRATIC_REPUBLIC_OF_THE_CONGO = "Democratic Republic of the Congo"
    CÔTE_DIVOIRE = "Côte d'Ivoire"
    BARBADOS = "Barbados"
    KYRGYZSTAN = "Kyrgyzstan"
    IRAQ = "Iraq"
    QATAR = "Qatar"
    CONGO = "Congo, Republic of the..."
    NOMADIC = "Nomadic"
    LIBYAN_ARAB_JAMAHIRIYA = "Libyan Arab Jamahiriya"
    MOZAMBIQUE = "Mozambique"
    ANGOLA = "Angola"
    OMAN = "Oman"
    YEMEN = "Yemen"
    SUDAN = "Sudan"
    SOMALIA = "Somalia"
    GUINEA = "Guinea"
    ZIMBABWE = "Zimbabwe"
    CAPE_VERDE = "Cape Verde"
    TRINIDAD_AND_TOBAGO = "Trinidad and Tobago"
    BENIN = "Benin"
    BHUTAN = "Bhutan"
    TOGO = "Togo"
    SURINAME = "Suriname"
    JAMAICA = "Jamaica"
    MALAWI = "Malawi"
    GUYANA = "Guyana"
    PALAU = "Palau"
    ZAMBIA = "Zambia"
    SEYCHELLES = "Seychelles"


class DeveloperStatus(str, Enum):
    SOMETIMES_DEV = (
        "I am not primarily a developer, but I write code sometimes as part of my work",
    )
    ALWAYS_DEV = "I am a developer by profession"


@app.get("/model_predict")
async def model_predict(
    years_coding: int,
    years_coding_pro: int,
    education_level: EducationLevel,
    developer_status: DeveloperStatus,
    country: Country,
):
    loaded_model = joblib.load("function/yearly-comp.pkl")
    # TODO: is there metadata in the model? get params?
    # could perhaps dynamically create enums based on the loaded model?

    X_new = numpy.array(
        [
            [
                years_coding,
                years_coding_pro,
                education_level.value,
                developer_status.value,
                country.value,
            ]
        ]
    )
    result = loaded_model.predict(X_new)
    return {"salary": round(result[0], 2)}


async def main(
    req: azure.functions.HttpRequest, context: azure.functions.Context
) -> azure.functions.HttpResponse:
    return azure.functions.AsgiMiddleware(app).handle(req, context)
