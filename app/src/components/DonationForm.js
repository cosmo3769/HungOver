import React, {useState} from 'react';
import { usePosition } from 'use-position';
import firebase from 'firebase/app';
import 'firebase/firestore';


export default function DonationForm() {

    const [donorName, setDonorName]=useState("");
    // const [location, setLocation]= useState('');
    const [numberofInvitedGuests, setNumberofInvitedGuests]= useState();
    const [numberOfGuestAttended, setNumberOfGuestAttended ]= useState();
    const [numberOfPlates, setNumberOfPlates] = useState();
    const [platesLeft, setPlatesLeft]= useState();
    const [typeOfFood, setTypeOfFood]= useState("");

    const watch = true;
    const {
        latitude,
        longitude,
        speed,
        timestamp,
        accuracy,
        error,
      } = usePosition(watch, {enableHighAccuracy: true});

    function addFood(e) {
        e.preventDefault();
        const db = firebase.firestore();
        db.collection("FoodData").add({
            name: `${donorName}`,
            peopleInvited: `${numberofInvitedGuests}`,
            peopleTurnedUp: `${numberOfGuestAttended}`,
            platesOrdered: `${numberOfPlates}`,
            platesRemaining: `${platesLeft}`,
            typeOfFood: `${typeOfFood}`
        });
    }


    return (
        <div>
            <form onSubmit={addFood}>
                <label>
                 Name:
                 <input type="text" name="name" required value={donorName} onChange={e => setDonorName(e.target.value)} />
                </label>
                <br />
                {/* <label>
                 Location:
                 <input type="location" name="location" required value={location} onChange={e => setLocation(e.target.value)} />
                </label>
                <br /> */}
                <label>
                 Number of people invited:
                 <input type="number" name="peopleInvited" required value={numberofInvitedGuests} onChange={e => setNumberofInvitedGuests(e.target.value)}/>
                </label>
                <br />
                <label>
                 Number of people that turned up:
                 <input type="number" name="peopleTurnedUp" required value={numberOfGuestAttended} onChange={e => setNumberOfGuestAttended(e.target.value)}/>
                </label>
                <br />
                <label>
                 Number of plates ordered:
                 <input type="number" name="platesOrdered" required value={numberOfPlates} onChange={e => setNumberOfPlates(e.target.value)}/>
                </label>
                <br />
                <label>
                 Number of plates remaining:
                 <input type="number" name="platesRemaining" required value={platesLeft} onChange={e => setPlatesLeft(e.target.value)}/>
                </label>
                <br />
                <label>
                 Type of food:
                 <input type="radio" id="non-veg" name="typeOfFood" value="non-veg" checked={typeOfFood==="non-veg"}  onChange={()=> setTypeOfFood('non-veg')}/>
                 <label htmlFor="non-veg">Non-Veg</label><br />
                 <input type="radio" id="veg" name="typeofFood" value="veg" checked={typeOfFood==="veg"} onChange={() => setTypeOfFood("veg")} />
                 <label htmlFor="veg">Veg</label><br />
                </label>
                <br />
                <code>
                    latitude: {latitude}<br/>
                    longitude: {longitude}<br/>
                    speed: {speed}<br/>
                    timestamp: {timestamp}<br/>
                    accuracy: {accuracy && `${accuracy}m`}<br/>
                    error: {error}
                </code>
                <br />
                <button type="submit" value="Submit">Submit</button>
            </form>
            
        </div>
    )
}