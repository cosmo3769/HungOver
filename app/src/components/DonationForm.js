import React from 'react';


export default function DonationForm() {
    return (
        <div>
            <form>
                <label>
                 Name:
                 <input type="text" name="name" />
                </label>
                <br />
                <label>
                 Location:
                 <input type="location" name="location" />
                </label>
                <br />
                <label>
                 Number of people invited:
                 <input type="number" name="people invited" />
                </label>
                <br />
                <label>
                 Number of people that turned up:
                 <input type="number" name="people turned up" />
                </label>
                <br />
                <label>
                 Number of plates ordered:
                 <input type="number" name="Plates ordered" />
                </label>
                <br />
                <label>
                 Number of plates remaining:
                 <input type="number" name="Plates remaining" />
                </label>
                <br />
                <label>
                 Type of food:
                 <input type="text" name="type" placeholder="veg or nonveg"/>
                </label>
                <br />
                <input type="submit" value="Submit" />
            </form>
            
        </div>
    )
}