using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Dirge : Ability
    {
        public Dirge()
        {
            Name = "Dirge";
            FlavorText = "A mournful song that saps the enemy's will to move.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
