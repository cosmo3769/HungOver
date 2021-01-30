import React, {useState} from 'react';


export default function DonationForm() {

    const [donorName, setDonorName]=useState("");
    const [location, setLocation]= useState("");
    const [numberofInvitedGuests, setNumberofInvitedGuests]= useState();
    const [numberOfGuestAttended, setNumberOfGuestAttended ]= useState();
    const [numberOfPlates, setNumberOfPlates] = useState();
    const [platesLeft, setPlatesLeft]= useState();
    const [typeOfFood, setTypeOfFood]= useState("");

    return (
        <div>
            <form>
                <label>
                 Name:
                 <input type="text" name="name" required value={donorName} onChange={e => setDonorName(e.target.value)} />
                </label>
                <br />
                <label>
                 Location:
                 <input type="location" name="location" required value={location} onChange={e => setLocation(e.target.value)} />
                </label>
                <br />
                <label>
                 Number of people invited:
                 <input type="number" name="people invited" required value={numberofInvitedGuests} onChange={e => setNumberofInvitedGuests(e.target.value)}/>
                </label>
                <br />
                <label>
                 Number of people that turned up:
                 <input type="number" name="people turned up" required value={numberOfGuestAttended} onChange={e => setNumberOfGuestAttended(e.target.value)}/>
                </label>
                <br />
                <label>
                 Number of plates ordered:
                 <input type="number" name="Plates ordered" required value={numberOfPlates} onChange={e => setNumberOfPlates(e.target.value)}/>
                </label>
                <br />
                <label>
                 Number of plates remaining:
                 <input type="number" name="Plates remaining" required value={platesLeft} onChange={e => setPlatesLeft(e.target.value)}/>
                </label>
                <br />
                <label>
                 Type of food:
                 <input type="radio" id="non-veg" name="typeofFood" value="non-veg" checked={typeOfFood==="non-veg"}  onChange={()=> setTypeOfFood('non-veg')}/>
                 <label htmlFor="non-veg">Non-Veg</label><br />
                 <input type="radio" id="veg" name="typeofFood" value="veg" checked={typeOfFood==="veg"} onChange={() => setTypeOfFood("veg")} />
                 <label htmlFor="veg">Veg</label><br />
                </label>
                <br />
                <input type="submit" value="Submit" />
            </form>
            
        </div>
    )
}