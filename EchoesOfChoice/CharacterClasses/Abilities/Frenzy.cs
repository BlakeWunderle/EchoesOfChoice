using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Frenzy : Ability
    {
        public Frenzy()
        {
            Name = "Frenzy";
            FlavorText = "Enter a wild frenzy, boosting your attack power.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 2;
        }
    }
}
