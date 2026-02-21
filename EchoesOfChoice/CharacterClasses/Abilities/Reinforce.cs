using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Reinforce : Ability
    {
        public Reinforce()
        {
            Name = "Reinforce";
            FlavorText = "Forge additional armor plating for a teammate. Increases defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
            TargetAll = true;
        }
    }
}
