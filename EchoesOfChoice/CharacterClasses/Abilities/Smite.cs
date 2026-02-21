using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Smite : Ability
    {
        public Smite()
        {
            Name = "Smite";
            FlavorText = "Call down divine judgment to strike an enemy with radiant force.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 9;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
