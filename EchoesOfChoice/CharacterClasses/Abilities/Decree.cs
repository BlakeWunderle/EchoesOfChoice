using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Decree : Ability
    {
        public Decree()
        {
            Name = "Decree";
            FlavorText = "An authoritative command that weakens the enemy's resolve.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
