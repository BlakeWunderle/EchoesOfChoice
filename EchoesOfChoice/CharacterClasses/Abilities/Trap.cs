using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Trap : Ability
    {
        public Trap()
        {
            Name = "Trap";
            FlavorText = "Scatter caltrops and tripwires around your position. Increases defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 2;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 1;
        }
    }
}
